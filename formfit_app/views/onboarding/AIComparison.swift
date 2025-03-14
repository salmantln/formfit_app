//
//  AIComparison.swift
//  formfit_app
//
//  Created by Salman Lartey on 05/03/2025.
//
import SwiftUI

struct AIComparison: View {
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
                    .frame(width: 96, height: 4)
                    .foregroundColor(.black)
                
                Rectangle()
                    .frame(width: 40, height: 4)
                    .foregroundColor(.gray.opacity(0.3))
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Lose twice as much weight with Cal AI vs on your own")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.top, 24)
                
                // Comparison card
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 320)
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 30) {
                            // Without Cal AI
                            VStack(spacing: 12) {
                                Text("Without\nFormfit")
                                    .font(.system(size: 16, weight: .medium))
                                    .multilineTextAlignment(.center)
                                
                                ZStack(alignment: .bottom) {
                                    // White background rectangle
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .frame(width: 100, height: 200)
                                    
                                    // Gray rectangle at the bottom
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray)
                                        .frame(width: 100, height: 40)
                                    
                                    // Text on top of gray rectangle
                                    Text("20%")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.black)
                                        .offset(y: -20)
                                }
                            }
                            
                            // With Cal AI
                            VStack(spacing: 12) {
                                Text("With\nFormfit")
                                    .font(.system(size: 16, weight: .medium))
                                    .multilineTextAlignment(.center)
                                
                                ZStack(alignment: .bottom) {
                                    // White background rectangle
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .frame(width: 100, height: 200)
                                    
                                    // Black rectangle at the bottom
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.black)
                                        .frame(width: 100, height: 80)
                                    
                                    // Text on top of black rectangle
                                    Text("2X")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                        .offset(y: -20)
                                }
                            }
                        }
                        
                        // Explanation text below both ZStacks
                        Text("Formfit makes it easy and holds you accountable.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 8)
                    }
                    .padding(.top, 16)
                }
                .padding(.top, 20)
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

struct AIComparison_Previews: PreviewProvider {
    static var previews: some View {
        AIComparison()
            .environmentObject(OnboardingState())
    }
}
