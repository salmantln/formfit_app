//
//  ExerciseControlPanel.swift
//  formfit_app
//
//  Created by Salman Lartey on 14/03/2025.
//

import SwiftUI

struct ExerciseControlPanel: View {
    let exerciseName: String
    let timeRemaining: Int
    let repCount: Int
    let isPaused: Bool
    let onPreviousExercise: () -> Void
    let onTogglePause: () -> Void
    let onNextExercise: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Exercise name with volume icon
            HStack {
                Text(exerciseName)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "speaker.wave.2")
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Timer and rep counter
            HStack(alignment: .top) {
                // Time remaining
                VStack(spacing: 0) {
                    Text("\(timeRemaining)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("remaining")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                
                // Rep counter
                VStack(spacing: 0) {
                    Text("\(repCount)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("reps")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 8)
            
            Divider()
                .padding(.horizontal)
            
            // Control buttons
            HStack {
                // Previous exercise
                Button(action: onPreviousExercise) {
                    Image(systemName: "backward.fill")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                
                // Play/Pause
                Button(action: onTogglePause) {
                    Image(systemName: isPaused ? "play.fill" : "pause.fill")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                
                // Next exercise
                Button(action: onNextExercise) {
                    Image(systemName: "forward.fill")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 8)
        }
        .background(Color.white)
        .cornerRadius(12)
    }
}

// Timer with formatting (:10 style)
struct FormattedTimeView: View {
    let seconds: Int
    
    var body: some View {
        Text(":\(String(format: "%02d", seconds))")
            .font(.system(size: 36, weight: .bold))
            .monospacedDigit()
    }
}
