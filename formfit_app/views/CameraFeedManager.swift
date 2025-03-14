//
//  MoveNetPoseEstimator.swift
//  formfit_app
//
//  Created by Salman Lartey on 09/03/2025.
//

import TensorFlowLite
import CoreImage
import CoreVideo

class MoveNetPoseEstimator {
    private var interpreter: Interpreter

    init() {
        // Load the MoveNet model from the app bundle
        guard let modelPath = Bundle.main.path(forResource: "4", ofType: "tflite") else {
            fatalError("Failed to load MoveNet model")
        }

        do {
            interpreter = try Interpreter(modelPath: modelPath)
            try interpreter.allocateTensors()
        } catch {
            fatalError("Failed to create TensorFlow Lite interpreter: \(error)")
        }
    }

    func estimatePose(from pixelBuffer: CVPixelBuffer) -> [CGPoint] {
        do {
            let inputTensor = try interpreter.input(at: 0)
            let imageData = preprocess(pixelBuffer: pixelBuffer, size: inputTensor.shape.dimensions)

            try interpreter.copy(imageData, toInputAt: 0)
            try interpreter.invoke()

            let outputTensor = try interpreter.output(at: 0)
            return processOutput(outputTensor: outputTensor)
        } catch {
            print("Pose estimation error: \(error)")
            return []
        }
    }

    private func preprocess(pixelBuffer: CVPixelBuffer, size: [Int]) -> Data {
        let context = CIContext()
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let resizedImage = ciImage.transformed(by: CGAffineTransform(scaleX: CGFloat(size[1]) / ciImage.extent.width, y: CGFloat(size[2]) / ciImage.extent.height))

        guard let cgImage = context.createCGImage(resizedImage, from: resizedImage.extent) else {
            fatalError("Failed to create CGImage")
        }

        let imageData = NSMutableData()
        let bitmapInfo = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue
        let contextRef = CGContext(
            data: imageData.mutableBytes,
            width: size[1],
            height: size[2],
            bitsPerComponent: 8,
            bytesPerRow: size[1] * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: bitmapInfo
        )

        contextRef?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size[1], height: size[2]))
        return imageData as Data
    }

    private func processOutput(outputTensor: Tensor) -> [CGPoint] {
        let outputArray = outputTensor.data.withUnsafeBytes {
            Array($0.bindMemory(to: Float32.self))
        }

        var points: [CGPoint] = []
        for i in stride(from: 0, to: outputArray.count, by: 3) {
            let x = CGFloat(outputArray[i]) * UIScreen.main.bounds.width
            let y = CGFloat(outputArray[i + 1]) * UIScreen.main.bounds.height
            points.append(CGPoint(x: x, y: y))
        }
        return points
    }
}
