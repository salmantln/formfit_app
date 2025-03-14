import Foundation
import CoreImage
import Vision
//import TensorFlow
import TensorFlowLite

class MoveNetModel {
    enum ModelType {
        case lightning // Faster but less accurate
        case thunder // More accurate but slower
    }
    
    private let interpreter: Interpreter
    private let inputSize: Int
    private let keypointNames = [
        "nose", "left_eye", "right_eye", "left_ear", "right_ear",
        "left_shoulder", "right_shoulder", "left_elbow", "right_elbow",
        "left_wrist", "right_wrist", "left_hip", "right_hip",
        "left_knee", "right_knee", "left_ankle", "right_ankle"
    ]
    
    private var lastInferenceTime: TimeInterval = 0
    
    init(modelType: ModelType = .lightning) throws {
        // Define the model name based on type
        let modelName: String
        switch modelType {
        case .lightning:
            modelName = "movenet_singlepose_lightning"
            inputSize = 192
        case .thunder:
            modelName = "movenet_singlepose_thunder"
            inputSize = 256
        }
        
        // Get the model URL
        guard let modelPath = Bundle.main.path(forResource: modelName, ofType: "tflite") else {
            throw NSError(domain: "MoveNetModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to load MoveNet model"])
        }
        
        // Initialize the interpreter
        interpreter = try Interpreter(modelPath: modelPath)
        
        // Allocate tensors
        try interpreter.allocateTensors()
    }
    
    func detect(frame: CVPixelBuffer) -> [Keypoint] {
        let startTime = CACurrentMediaTime()
        
        do {
            // Prepare input image
            let inputTensor = try prepareInputTensor(frame: frame)
            
            // Run inference
            try interpreter.invoke()
            
            // Process results
            let keypoints = try processOutputTensor()
            
            // Calculate inference time
            lastInferenceTime = CACurrentMediaTime() - startTime
            
            return keypoints
        } catch {
            print("Error running MoveNet: \(error)")
            return []
        }
    }
    
    func inferenceTime() -> TimeInterval {
        return lastInferenceTime
    }
    
    private func prepareInputTensor(frame: CVPixelBuffer) throws -> Data {
        // Get input tensor information
        let inputTensor = try interpreter.input(at: 0)
        
        // Resize and normalize the image
        let ciImage = CIImage(cvPixelBuffer: frame)
        let context = CIContext()
        
        // Create a resized image
        let scale = CGFloat(inputSize) / CGFloat(max(CVPixelBufferGetWidth(frame), CVPixelBufferGetHeight(frame)))
        let scaledImage = ciImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        
        // Center crop to inputSize x inputSize
        let cropRect = CGRect(
            x: (scaledImage.extent.width - CGFloat(inputSize)) / 2,
            y: (scaledImage.extent.height - CGFloat(inputSize)) / 2,
            width: CGFloat(inputSize),
            height: CGFloat(inputSize)
        )
        let croppedImage = scaledImage.cropped(to: cropRect)
        
        // Create a new pixel buffer
        var newPixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(
            kCFAllocatorDefault,
            inputSize,
            inputSize,
            kCVPixelFormatType_32BGRA,
            nil,
            &newPixelBuffer
        )
        
        guard let newPixelBuffer = newPixelBuffer else {
            throw NSError(domain: "MoveNetModel", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to create pixel buffer"])
        }
        
        // Render the image to the pixel buffer
        context.render(croppedImage, to: newPixelBuffer)
        
        // Copy the pixel buffer to input tensor as [0-255] uint8 data
        let bytesPerRow = CVPixelBufferGetBytesPerRow(newPixelBuffer)
        let bufferSize = CVPixelBufferGetDataSize(newPixelBuffer)
        
        CVPixelBufferLockBaseAddress(newPixelBuffer, .readOnly)
        guard let baseAddress = CVPixelBufferGetBaseAddress(newPixelBuffer) else {
            CVPixelBufferUnlockBaseAddress(newPixelBuffer, .readOnly)
            throw NSError(domain: "MoveNetModel", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to get pixel buffer base address"])
        }
        
        // Convert data to Float32 and normalize to [0-1]
        let width = inputSize
        let height = inputSize
        let channels = 3 // RGB
        var floatData = Data(count: width * height * channels * MemoryLayout<Float32>.size)
        
        floatData.withUnsafeMutableBytes { floatBuffer in
            let floatPointer = floatBuffer.bindMemory(to: Float32.self).baseAddress!
            
            for y in 0..<height {
                for x in 0..<width {
                    let pixelOffset = y * bytesPerRow + x * 4
                    let pixel = baseAddress.advanced(by: pixelOffset).bindMemory(to: UInt8.self, capacity: 4)
                    
                    // BGRA to RGB and normalize to [0-1]
                    let r = Float32(pixel[2]) / 255.0
                    let g = Float32(pixel[1]) / 255.0
                    let b = Float32(pixel[0]) / 255.0
                    
                    let floatIndex = (y * width + x) * channels
                    floatPointer[floatIndex] = r
                    floatPointer[floatIndex + 1] = g
                    floatPointer[floatIndex + 2] = b
                }
            }
        }
        
        CVPixelBufferUnlockBaseAddress(newPixelBuffer, .readOnly)
        
        return floatData
    }
    
    private func processOutputTensor() throws -> [Keypoint] {
        // Get output tensor
        let outputTensor = try interpreter.output(at: 0)
        
        // Extract keypoints from output tensor
        // MoveNet returns a tensor of shape [1, 1, 17, 3] where last dimensions are [y, x, confidence]
        let keypointCount = 17
        var keypoints: [Keypoint] = []
        
        outputTensor.data.withUnsafeBytes { buffer in
            let outputPtr = buffer.bindMemory(to: Float32.self).baseAddress!
            
            for i in 0..<keypointCount {
                let baseOffset = i * 3
                let yPos = CGFloat(outputPtr[baseOffset])
                let xPos = CGFloat(outputPtr[baseOffset + 1])
                let score = Float(outputPtr[baseOffset + 2])
                
                let keypoint = Keypoint(
                    id: i,
                    x: xPos,
                    y: yPos,
                    part: keypointNames[i],
                    score: score
                )
                keypoints.append(keypoint)
            }
        }
        
        return keypoints
    }
}
