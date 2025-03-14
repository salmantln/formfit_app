//
//  GraphView.swift
//  formfit_app
//
//  Created by Salman Lartey on 05/03/2025.
//

import SwiftUI


// AI Results Screen (Image 1)

// Custom graph view for the weight comparison chart
struct GraphView: View {
    var body: some View {
        ZStack {
            // Traditional diet curve (red)
            Path { path in
                path.move(to: CGPoint(x: 0, y: 50))
                path.addCurve(
                    to: CGPoint(x: 300, y: 80),
                    control1: CGPoint(x: 100, y: 10),
                    control2: CGPoint(x: 200, y: 70)
                )
            }
            .stroke(Color.red, lineWidth: 2)
            
            // Red shaded area
            Path { path in
                path.move(to: CGPoint(x: 300, y: 80))
                path.addLine(to: CGPoint(x: 300, y: 0))
                path.addLine(to: CGPoint(x: 200, y: 0))
                path.addCurve(
                    to: CGPoint(x: 300, y: 80),
                    control1: CGPoint(x: 230, y: 40),
                    control2: CGPoint(x: 270, y: 70)
                )
            }
            .fill(Color.red.opacity(0.1))
            
            // Cal AI curve (black)
            Path { path in
                path.move(to: CGPoint(x: 0, y: 50))
                path.addCurve(
                    to: CGPoint(x: 300, y: 40),
                    control1: CGPoint(x: 100, y: 90),
                    control2: CGPoint(x: 200, y: 30)
                )
            }
            .stroke(Color.black, lineWidth: 2)
            
            // Start dot
            Circle()
                .fill(Color.black)
                .frame(width: 10, height: 10)
                .offset(x: -150, y: 0)
            
            // End dot
            Circle()
                .fill(Color.black)
                .frame(width: 10, height: 10)
                .offset(x: 150, y: -10)
        }
    }
}

