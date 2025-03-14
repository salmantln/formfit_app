//
//  BarriersSelectionScreen.swift
//  formfit_app
//
//  Created by Salman Lartey on 05/03/2025.
//

import SwiftUI

struct BarriersSelectionScreen: View {
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
                    .frame(width: 112, height: 4)
                    .foregroundColor(.black)
                
                Rectangle()
                    .frame(width: 24, height: 4)
                    .foregroundColor(.gray.opacity(0.3))
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("What's stopping you from reaching your goals?")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.top, 24)
                
                // Barriers options
                VStack(spacing: 12) {
                    ForEach(onboardingState.barrierOptions, id: \.self) { barrier in
                        Button(action: {
                            onboardingState.toggleBarrier(barrier)
                        }) {
                            HStack {
                                // Icon based on barrier type
                                Group {
                                    if barrier == "Lack of consistency" {
                                        Image(systemName: "chart.bar.fill")
                                    } else if barrier == "Unhealthy eating habits" {
                                        Image(systemName: "pills.fill")
                                    } else if barrier == "Lack of support" {
                                        Image(systemName: "heart.fill")
                                    } else if barrier == "Busy schedule" {
                                        Image(systemName: "calendar")
                                    } else if barrier == "Lack of meal inspiration" {
                                        Image(systemName: "flame.fill")
                                    }
                                }
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                
                                Text(barrier)
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                                    .padding(.leading, 12)
                                
                                Spacer()
                                
                                if onboardingState.barriers.contains(barrier) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(onboardingState.barriers.contains(barrier) ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1))
                            )
                        }
                    }
                }
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
                            .fill(Color.gray)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
    }
}

struct BarriersSelectionScreen_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock OnboardingState with test values
        let testState = OnboardingState()
        
        // Optional: Set some barriers to test selected state
        testState.barriers = ["Lack of consistency", "Busy schedule"]
        
        return BarriersSelectionScreen()
            .environmentObject(testState)
    }
}
