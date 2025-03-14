//
//  AiResultsScreen.swift
//  formfit_app
//
//  Created by Salman Lartey on 05/03/2025.
//
import SwiftUI

struct AIResultsScreen: View {
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
                    .frame(width: 64, height: 4)
                    .foregroundColor(.black)
                
                Rectangle()
                    .frame(width: 72, height: 4)
                    .foregroundColor(.gray.opacity(0.3))
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Formfit creates long-term results")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.top, 24)
                
                
                // Weight graph card
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.1))
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your Weight")
                            .font(.system(size: 16, weight: .medium))
                            .padding(.top, 16)
                            .padding(.leading, 16)
                        
                        // Custom graph
                        ZStack {
                            // Create the graph paths
                            GraphView()
                                .padding(.horizontal, 16)
                            
                            // Month labels
                            HStack {
                                Text("Month 1")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Text("Month 6")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 24)
                            .offset(y: 40)
                            
                            // Graph legend
                            HStack {
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(Color.black)
                                        .frame(width: 8, height: 8)
                                    
                                    Text("FormFit")
                                        .font(.system(size: 10))
                                        .foregroundColor(.black)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.black.opacity(0.1))
                                .cornerRadius(12)
                                
                                Text("Traditional Diet")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                    .padding(.leading, 80)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .offset(y: -40)
                        }
                        .frame(height: 120)
                        
                        // Results text
                        Text("80% of Cal AI users maintain their weight loss even 6 months later")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                    }
                }
                .frame(height: 240)
                .padding(.horizontal, 16)
            }
            .padding(.horizontal,20)
            
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

struct AIResultsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AIResultsScreen()
    }
}
