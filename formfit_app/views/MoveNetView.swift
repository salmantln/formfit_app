////
////  MoveNetView.swift
////  formfit_app
////
////  Created by Salman Lartey on 10/03/2025.
////
//
//import SwiftUI
//import AVFoundation
//import TensorFlowLite
//
//struct MoveNetView: View {
//    @StateObject private var cameraModel = CameraModel()
//    
//    var body: some View {
//        ZStack {
//            CameraPreview(session: cameraModel.session)
//                .ignoresSafeArea()
//            
//            // Display Pose Points
//            ForEach(cameraModel.posePoints, id: \.[0]) { point in
//                Circle()
//                    .fill(Color.red)
//                    .frame(width: 10, height: 10)
//                    .position(x: point[0], y: point[1])
//            }
//        }
//        .onAppear {
//            cameraModel.startSession()
//        }
//        .onDisappear {
//            cameraModel.stopSession()
//        }
//    }
//}
//
//class CameraModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
//    let session = AVCaptureSession()
//    private let model = MoveNetModel()
//    @Published var posePoints: [[CGFloat]] = []
//    
//    override init() {
//        super.init()
//        setupCamera()
//    }
//    
//    func setupCamera() {
//        session.sessionPreset = .high
//        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
//        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
//        
//        if session.canAddInput(input) {
//            session.addInput(input)
//        }
//        
//        let output = AVCaptureVideoDataOutput()
//        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//        if session.canAddOutput(output) {
//            session.addOutput(output)
//        }
//    }
//    
//    func startSession() {
//        session.startRunning()
//    }
//    
//    func stopSession() {
//        session.stopRunning()
//    }
//    
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//        DispatchQueue.global(qos: .userInteractive).async {
//            if let keypoints = self.model.detectPose(from: pixelBuffer) {
//                DispatchQueue.main.async {
//                    self.posePoints = keypoints
//                }
//            }
//        }
//    }
//}
//
//struct CameraPreview: UIViewRepresentable {
//    let session: AVCaptureSession
//    
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView(frame: UIScreen.main.bounds)
//        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer.videoGravity = .resizeAspectFill
//        previewLayer.frame = view.frame
//        view.layer.addSublayer(previewLayer)
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIView, context: Context) {}
//}
//
//class MoveNetModel {
//    private var interpreter: Interpreter?
//    
//    init() {
//        do {
//            if let modelPath = Bundle.main.path(forResource: "4", ofType: "tflite") {
//                interpreter = try Interpreter(modelPath: modelPath)
//                print("Succes!")
//            }
//        } catch {
//            print("Failed to load model: \(error)")
//        }
//    }
//    
//    
//    func detectPose(from pixelBuffer: CVPixelBuffer) -> [[CGFloat]]? {
//        // Convert pixelBuffer to Tensor format, run model, and process output
//        // Placeholder for model inference logic
//        return [[100, 200], [150, 250], [200, 300]] // Dummy keypoints (replace with actual output processing)
//    }
//}
//
//struct MoveNetView_Previews: PreviewProvider {
//    static var previews: some View {
//        MoveNetView()
//    }
//}
