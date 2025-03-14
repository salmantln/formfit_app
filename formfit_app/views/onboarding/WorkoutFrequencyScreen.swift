//
//  WorkoutFrequencyScreen.swift
//  formfit_app
//
//  Created by Salman Lartey on 05/03/2025.
//

import SwiftUI

struct WorkoutFrequencyScreen: View {
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
                    .frame(width: 32, height: 4)
                    .foregroundColor(.black)
                    .padding(.trailing, 4)
                
                Rectangle()
                    .frame(width: 104, height: 4)
                    .foregroundColor(.gray.opacity(0.3))
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("How many workouts do you do per week?")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.top, 24)
                
                Text("This will be used to calibrate your custom plan.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                
                
                // Workout frequency options
                VStack(spacing: 12) {
                    Button(action: {
                        onboardingState.workoutsPerWeek = "0-2"
                    }) {
                        HStack {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 8, height: 8)
                            
                            Text("0-2")
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .padding(.leading, 8)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 72)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(onboardingState.workoutsPerWeek == "0-2" ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1))
                        )
                    }
                    .overlay(
                        VStack {
                            Spacer()
                            Text("Workouts now and then")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .padding(.leading, 32)
                                .padding(.bottom, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    )
                    
                    Button(action: {
                        onboardingState.workoutsPerWeek = "3-5"
                    }) {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 8, height: 8)
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 4, y: 4)
                            }
                            
                            Text("3-5")
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .padding(.leading, 8)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 72)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(onboardingState.workoutsPerWeek == "3-5" ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1))
                        )
                    }
                    .overlay(
                        VStack {
                            Spacer()
                            Text("A few workouts per week")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .padding(.leading, 32)
                                .padding(.bottom, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    )
                    
                    Button(action: {
                        onboardingState.workoutsPerWeek = "6+"
                    }) {
                        HStack {
                            HStack(spacing: 2) {
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 6, height: 6)
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 6, height: 6)
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 6, height: 6)
                            }
                            
                            Text("6+")
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .padding(.leading, 8)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 72)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(onboardingState.workoutsPerWeek == "6+" ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1))
                        )
                    }
                    .overlay(
                        VStack {
                            Spacer()
                            Text("Dedicated athlete")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .padding(.leading, 32)
                                .padding(.bottom, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    )
                }
                .padding(.top, 16)
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Next button
            Button(action: {
                if !onboardingState.workoutsPerWeek.isEmpty {
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
                            .fill(onboardingState.workoutsPerWeek.isEmpty ? Color.gray.opacity(0.4) : Color.gray)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
            .disabled(onboardingState.workoutsPerWeek.isEmpty)
        }
    }
}
