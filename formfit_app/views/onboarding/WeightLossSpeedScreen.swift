//
//  WeightLossSpeedScreen.swift
//  formfit_app
//
//  Created by Salman Lartey on 05/03/2025.
//

import SwiftUI


struct WeightLossSpeedScreen: View {
    @EnvironmentObject var onboardingState: OnboardingState
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation header
            HStack {
                Button(action: {
                    onboardingState.previousStep()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .padding(12)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                // Progress indicator
                Rectangle()
                    .frame(width: 80, height: 4)
                    .foregroundColor(.black)
                
                Rectangle()
                    .frame(width: 56, height: 4)
                    .foregroundColor(.gray.opacity(0.3))
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("How fast do you want to reach your goal?")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.top, 24)
                
                Text("Loss weight speed per week")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .padding(.top, 20)
                
                // Current selected value
                Text("\(String(format: "%.1f", onboardingState.weightLossSpeed)) lbs")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 8)
                
                // Custom slider with animal icons
                ZStack(alignment: .leading) {
                    // Background track
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(.gray.opacity(0.3))
                    
                    // Filled track
                    Rectangle()
                        .frame(width: CGFloat((onboardingState.weightLossSpeed - 0.2) / 2.8) * UIScreen.main.bounds.width * 0.9, height: 4)
                        .foregroundColor(.black)
                    
                    // Turtle icon (slow)
                    Image(systemName: "tortoise.fill")
                        .foregroundColor(.black)
                        .background(Circle().fill(Color.white).frame(width: 30, height: 30))
                        .offset(x: -12, y: -20)
                    
                    // Rabbit icon (medium)
                    Image(systemName: "hare.fill")
                        .foregroundColor(.black)
                        .background(Circle().fill(Color.white).frame(width: 30, height: 30))
                        .offset(x: UIScreen.main.bounds.width * 0.43, y: -20)
                    
                    // Cheetah icon (fast)
                    Image(systemName: "cat.fill")
                        .foregroundColor(.black)
                        .background(Circle().fill(Color.white).frame(width: 30, height: 30))
                        .offset(x: UIScreen.main.bounds.width * 0.85, y: -20)
                    
                    // Labels
                    Text("0.2 lbs")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .offset(x: 0, y: 20)
                    
                    Text("1.5 lbs")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .offset(x: UIScreen.main.bounds.width * 0.43, y: 20)
                    
                    Text("3.0 lbs")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .offset(x: UIScreen.main.bounds.width * 0.85, y: 20)
                    
                    // Thumb
                    Circle()
                        .fill(Color.white)
                        .frame(width: 24, height: 24)
                        .shadow(radius: 2)
                        .offset(x: CGFloat((onboardingState.weightLossSpeed - 0.2) / 2.8) * UIScreen.main.bounds.width * 0.9 - 12)
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let percentage = min(max(0, value.location.x / (UIScreen.main.bounds.width * 0.9)), 1)
                            onboardingState.weightLossSpeed = Double(percentage) * 2.8 + 0.2
                            onboardingState.weightLossSpeed = round(onboardingState.weightLossSpeed * 10) / 10 // Round to 1 decimal
                        }
                )
                .padding(.top, 40)
                
                // Recommended indicator
                Text("Recommended")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                    )
                    .padding(.top, 40)
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Next button
            Button(action: {
                onboardingState.nextStep()
            }) {
                Text("Next")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.black)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
    }
}

struct WeightLossSpeedScreen_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock OnboardingState with test values
        let testState = OnboardingState()
        testState.weightLossSpeed = 1.5 // Set a test value
        
        return WeightLossSpeedScreen()
            .environmentObject(testState)
    }
}
