import SwiftUI

struct OverlayView: View {
    let keypoints: [Keypoint]
    let connections: [(from: Int, to: Int)]
    let frameSize: CGSize
    let viewSize: CGSize
    
    init(keypoints: [Keypoint],
         connections: [(from: Int, to: Int)] = PoseConnections.connections,
         frameSize: CGSize,
         viewSize: CGSize) {
        self.keypoints = keypoints
        self.connections = connections
        self.frameSize = frameSize
        self.viewSize = viewSize
    }
    
    var body: some View {
        ZStack {
            // Draw connections (lines between joints)
            ForEach(Array(zip(connections.indices, connections)), id: \.0) { index, connection in
                if let fromPoint = normalizedToViewCoordinates(keypoints[connection.from].position),
                   let toPoint = normalizedToViewCoordinates(keypoints[connection.to].position),
                   keypoints[connection.from].score > 0.3,
                   keypoints[connection.to].score > 0.3 {
                    
                    Path { path in
                        path.move(to: fromPoint)
                        path.addLine(to: toPoint)
                    }
                    .stroke(Color.green, lineWidth: 3)
                }
            }
            
            // Draw keypoints (joints)
            ForEach(keypoints.indices, id: \.self) { index in
                if let position = normalizedToViewCoordinates(keypoints[index].position),
                   keypoints[index].score > 0.3 {
                    Circle()
                        .fill(keypointColor(for: keypoints[index].score))
                        .frame(width: 12, height: 12)
                        .position(position)
                }
            }
        }
        .frame(width: viewSize.width, height: viewSize.height)
    }
    
    // Convert normalized coordinates (0.0-1.0) to view coordinates
    private func normalizedToViewCoordinates(_ normalizedPoint: CGPoint) -> CGPoint? {
        // Filter out invalid points
        guard normalizedPoint.x >= 0, normalizedPoint.x <= 1.0,
              normalizedPoint.y >= 0, normalizedPoint.y <= 1.0 else {
            return nil
        }
        
        // Adjust for aspect ratio differences between source and destination
        let aspectRatioFactor = min(
            viewSize.width / frameSize.width,
            viewSize.height / frameSize.height
        )
        
        let scaledWidth = frameSize.width * aspectRatioFactor
        let scaledHeight = frameSize.height * aspectRatioFactor
        
        let xOffset = (viewSize.width - scaledWidth) / 2
        let yOffset = (viewSize.height - scaledHeight) / 2
        
        // Flip Y axis as image coordinates start from top-left
        return CGPoint(
            x: normalizedPoint.x * scaledWidth + xOffset,
            y: normalizedPoint.y * scaledHeight + yOffset
        )
    }
    
    // Color based on confidence score
    private func keypointColor(for score: Float) -> Color {
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

// Model to represent a keypoint (body joint)
struct Keypoint: Identifiable {
    var id: Int
    let position: CGPoint
    let part: String
    let score: Float
    
    init(id: Int, x: CGFloat, y: CGFloat, part: String, score: Float) {
        self.id = id
        self.position = CGPoint(x: x, y: y)
        self.part = part
        self.score = score
    }
}

// Define the connections between body keypoints
struct PoseConnections {
    static let connections: [(from: Int, to: Int)] = [
        // Torso
        (0, 1), // nose to left eye
        (0, 2), // nose to right eye
        (1, 3), // left eye to left ear
        (2, 4), // right eye to right ear
        (0, 5), // nose to left shoulder
        (0, 6), // nose to right shoulder
        (5, 6), // left shoulder to right shoulder
        (5, 7), // left shoulder to left elbow
        (6, 8), // right shoulder to right elbow
        (7, 9), // left elbow to left wrist
        (8, 10), // right elbow to right wrist
        (5, 11), // left shoulder to left hip
        (6, 12), // right shoulder to right hip
        (11, 12), // left hip to right hip
        (11, 13), // left hip to left knee
        (12, 14), // right hip to right knee
        (13, 15), // left knee to left ankle
        (14, 16) // right knee to right ankle
    ]
}
