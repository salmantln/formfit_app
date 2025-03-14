import SwiftUI
import AVFoundation
import Vision

struct MoveNetTestView: View {
    @StateObject private var viewModel = MoveNetViewModel()
    
    var body: some View {
        ZStack {
            // Combined camera view with overlay
            CameraWithOverlayView(
                session: viewModel.session,
                keypoints: viewModel.keypoints,
                frameSize: viewModel.frameSize
            )
            .edgesIgnoringSafeArea(.all)
            
            // Debugging info
            VStack {
//                Spacer()
                
                HStack {
                    Text("FPS: \(viewModel.fps, specifier: "%.1f")")
                        .padding(8)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    // Model selector
                    Picker("Model", selection: $viewModel.modelType) {
                        Text("Lightning").tag(MoveNetModel.ModelType.lightning)
                        Text("Thunder").tag(MoveNetModel.ModelType.thunder)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(8)
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.startSession()
        }
        .onDisappear {
            viewModel.stopSession()
        }
    }
}

// Combined camera view with overlay
struct CameraWithOverlayView: UIViewRepresentable {
    let session: AVCaptureSession
    let keypoints: [Keypoint]
    let frameSize: CGSize
    
    func makeUIView(context: Context) -> OverlayContainerView {
        let container = OverlayContainerView(frame: UIScreen.main.bounds, session: session)
        return container
    }
    
    func updateUIView(_ uiView: OverlayContainerView, context: Context) {
        // Update preview layer size
        uiView.updateFrame()
        
        // Update overlay with new keypoints
        uiView.updateOverlay(with: keypoints, frameSize: frameSize)
    }
}

// Custom UIView that holds both camera preview and overlay
class OverlayContainerView: UIView {
    private let previewLayer: AVCaptureVideoPreviewLayer
    private let overlayLayer = CAShapeLayer()
    
    init(frame: CGRect, session: AVCaptureSession) {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        super.init(frame: frame)
        
        // Setup camera preview
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = bounds
        layer.addSublayer(previewLayer)
        
        // Setup overlay
        overlayLayer.frame = bounds
        overlayLayer.fillColor = nil
        overlayLayer.lineWidth = 3.0
        layer.addSublayer(overlayLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateFrame() {
        previewLayer.frame = bounds
        overlayLayer.frame = bounds
    }
    
    func updateOverlay(with keypoints: [Keypoint], frameSize: CGSize) {
        // Clear previous paths
        overlayLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        guard !keypoints.isEmpty else { return }
        
        // Create connections between joints
        for connection in PoseConnections.connections {
            let fromKeypoint = keypoints[connection.from]
            let toKeypoint = keypoints[connection.to]
            
            // Skip if confidence is too low
            guard fromKeypoint.score > 0.3, toKeypoint.score > 0.3 else { continue }
            
            // Convert normalized coordinates to view coordinates
            guard let fromPoint = normalizedToViewCoordinates(fromKeypoint.position, frameSize: frameSize),
                  let toPoint = normalizedToViewCoordinates(toKeypoint.position, frameSize: frameSize) else {
                continue
            }
            
            // Create connection line
            let linePath = UIBezierPath()
            linePath.move(to: fromPoint)
            linePath.addLine(to: toPoint)
            
            let lineLayer = CAShapeLayer()
            lineLayer.path = linePath.cgPath
            lineLayer.strokeColor = UIColor.green.cgColor
            lineLayer.lineWidth = 3.0
            lineLayer.fillColor = nil
            
            overlayLayer.addSublayer(lineLayer)
        }
        
        // Draw keypoints
        for keypoint in keypoints {
            guard keypoint.score > 0.3,
                  let position = normalizedToViewCoordinates(keypoint.position, frameSize: frameSize) else {
                continue
            }
            
            let circleLayer = CAShapeLayer()
            let circlePath = UIBezierPath(arcCenter: position,
                                         radius: 6,
                                         startAngle: 0,
                                         endAngle: CGFloat(2 * Double.pi),
                                         clockwise: true)
            
            circleLayer.path = circlePath.cgPath
            circleLayer.fillColor = keypointColor(for: keypoint.score).cgColor
            
            overlayLayer.addSublayer(circleLayer)
        }
    }
    
    // Convert normalized coordinates (0.0-1.0) to view coordinates
    private func normalizedToViewCoordinates(_ normalizedPoint: CGPoint, frameSize: CGSize) -> CGPoint? {
        // Filter out invalid points
        guard normalizedPoint.x >= 0, normalizedPoint.x <= 1.0,
              normalizedPoint.y >= 0, normalizedPoint.y <= 1.0 else {
            return nil
        }
        
        // Adjust for aspect ratio differences between source and destination
        let aspectRatioFactor = min(
            bounds.width / frameSize.width,
            bounds.height / frameSize.height
        )
        
        let scaledWidth = frameSize.width * aspectRatioFactor
        let scaledHeight = frameSize.height * aspectRatioFactor
        
        let xOffset = (bounds.width - scaledWidth) / 2
        let yOffset = (bounds.height - scaledHeight) / 2
        
        // Flip Y axis as image coordinates start from top-left
        return CGPoint(
            x: normalizedPoint.x * scaledWidth + xOffset,
            y: normalizedPoint.y * scaledHeight + yOffset
        )
    }
    
    // Color based on confidence score
    private func keypointColor(for score: Float) -> UIColor {
        switch score {
        case 0.7...1.0:
            return .red
        case 0.5..<0.7:
            return .orange
        default:
            return .yellow
        }
    }
}

// View Model to handle camera session and MoveNet processing
class MoveNetViewModel: NSObject, ObservableObject {
    @Published var keypoints: [Keypoint] = []
    @Published var fps: Double = 0
    @Published var modelType: MoveNetModel.ModelType = .lightning {
        didSet {
            initializeModel()
        }
    }
    
    var frameSize: CGSize = .zero
    let session = AVCaptureSession()
    private var model: MoveNetModel?
    private var lastFrameTime: Date?
    private var frameCount: Int = 0
    private var fpsUpdateTimer: Timer?
    
    override init() {
        super.init()
        initializeModel()
        setupCaptureSession()
        setupFPSCounter()
    }
    
    private func initializeModel() {
        do {
            model = try MoveNetModel(modelType: modelType)
        } catch {
            print("Failed to initialize MoveNet model: \(error)")
        }
    }
    
    private func setupCaptureSession() {
        // Specifically request the front camera
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("Failed to access the front camera")
            return
        }
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        output.alwaysDiscardsLateVideoFrames = true
        
        session.beginConfiguration()
        session.sessionPreset = .high
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        session.commitConfiguration()
        
        // Get frame size
        if let connection = output.connection(with: .video) {
            // Set video orientation to portrait
            connection.videoOrientation = .portrait
            
            // Enable auto orientation if available
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = .portrait
            }
            
            // Mirror front camera
            if captureDevice.position == .front && connection.isVideoMirroringSupported {
                connection.isVideoMirrored = true
            }
            
            // Get resolution
            let formatDescription = captureDevice.activeFormat.formatDescription
            let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
            frameSize = CGSize(width: CGFloat(dimensions.width), height: CGFloat(dimensions.height))
        }
    }
    
    private func setupFPSCounter() {
        fpsUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.fps = Double(self.frameCount)
                self.frameCount = 0
            }
        }
    }
    
    func startSession() {
        if !session.isRunning {
            session.startRunning()
        }
    }
    
    func stopSession() {
        if session.isRunning {
            session.stopRunning()
        }
        fpsUpdateTimer?.invalidate()
    }
}

// Handle camera frames
extension MoveNetViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
              let model = model else {
            return
        }
        
        // Update FPS counter
        frameCount += 1
        
        // Run pose detection
        let detectedKeypoints = model.detect(frame: pixelBuffer)
        
        // Update UI on main thread
        DispatchQueue.main.async { [weak self] in
            self?.keypoints = detectedKeypoints
        }
    }
}

// Preview provider for SwiftUI preview
struct MoveNetTestView_Previews: PreviewProvider {
    static var previews: some View {
        MoveNetTestView()
    }
}
