//
//  GenderSelection.swift
//  formfit_app
//
//  Created by Salman Lartey on 05/03/2025.
//

import SwiftUI

struct GenderSelectionScreen: View {
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
                    .frame(width: 16, height: 4)
                    .foregroundColor(.black)
                    .padding(.trailing, 4)
                
                Rectangle()
                    .frame(width: 120, height: 4)
                    .foregroundColor(.gray.opacity(0.3))
                
                Spacer()
                
                // Language button
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Text("🇺🇸")
                        Text("EN")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Choose your Gender")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.top, 24)
                
                Text("This will be used to calibrate your custom plan.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .padding(.bottom, 32)
                
                // Gender selection buttons
                VStack(spacing: 12) {
                    Button(action: {
                        onboardingState.selectedGender = "Male"
                    }) {
                        Text("Male")
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(onboardingState.selectedGender == "Male" ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1))
                            )
                    }
                    
                    Button(action: {
                        onboardingState.selectedGender = "Female"
                    }) {
                        Text("Female")
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(onboardingState.selectedGender == "Female" ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1))
                            )
                    }
                    
                    Button(action: {
                        onboardingState.selectedGender = "Other"
                    }) {
                        Text("Other")
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(onboardingState.selectedGender == "Other" ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1))
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Next button
            Button(action: {
                if !onboardingState.selectedGender.isEmpty {
                    onboardingState.nextStep()
                }
            }) {
                Text("Next")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(onboardingState.selectedGender.isEmpty ? Color.gray.opacity(0.4) : Color.gray)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
            .disabled(onboardingState.selectedGender.isEmpty)
        }
    }
}
