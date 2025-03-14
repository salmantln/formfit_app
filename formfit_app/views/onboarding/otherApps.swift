//
//  otherApps.swift
//  formfit_app
//
//  Created by Salman Lartey on 05/03/2025.
//
import SwiftUI

struct OtherAppsScreen: View {
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
                    .frame(width: 48, height: 4)
                    .foregroundColor(.black)
                    .padding(.trailing, 4)
                
                Rectangle()
                    .frame(width: 88, height: 4)
                    .foregroundColor(.gray.opacity(0.3))
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            Text("Have you tried other calorie tracking apps?")
                .font(.system(size: 28, weight: .bold))
                .padding(.top, 24)
                .padding(.bottom, 32)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer() // Push content to center vertically
            
            // Options - full width with centered content
            VStack(spacing: 12) {
                Button(action: {
                    onboardingState.triedOtherApps = "No"
                }) {
                    HStack {
                        Spacer()
                        
                        Image(systemName: "hand.thumbsdown.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                        
                        Text("No")
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .padding(.leading, 8)
                        
                        Spacer()
                    }
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(onboardingState.triedOtherApps == "No" ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1))
                    )
                }
                
                Button(action: {
                    onboardingState.triedOtherApps = "Yes"
                }) {
                    HStack {
                        Spacer()
                        
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                        
                        Text("Yes")
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .padding(.leading, 8)
                        
                        Spacer()
                    }
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(onboardingState.triedOtherApps == "Yes" ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1))
                    )
                }
            }
            .padding(.horizontal, 20) // Add horizontal padding to the VStack
            
            Spacer() // Push content to center vertically
            
            // Next button
            Button(action: {
                if !onboardingState.triedOtherApps.isEmpty {
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
                            .fill(onboardingState.triedOtherApps.isEmpty ? Color.gray.opacity(0.4) : Color.gray)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
            .disabled(onboardingState.triedOtherApps.isEmpty)
        }
    }
}
