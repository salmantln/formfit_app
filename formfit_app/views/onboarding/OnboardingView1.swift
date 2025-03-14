//
//  OnboardingView1.swift
//  formfit_app
//
//  Created by Salman Lartey on 05/03/2025.
//

import SwiftUI

// Main App Structure


// State manager for onboarding
class OnboardingState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool = false
    @Published var currentOnboardingStep: Int = 0
    @Published var selectedGender: String = ""
    @Published var workoutsPerWeek: String = ""
    @Published var triedOtherApps: String = ""
    
    // Second set of onboarding (Cal AI)
    @Published var weightLossSpeed: Double = 1.0
    @Published var barriers: [String] = []
    
    
    let barrierOptions = [
        "Lack of consistency",
        "Unhealthy eating habits",
        "Lack of support",
        "Busy schedule",
        "Lack of meal inspiration"
    ]
    
    func completeOnboarding() {
        // Save user preferences
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.set(selectedGender, forKey: "userGender")
        UserDefaults.standard.set(workoutsPerWeek, forKey: "workoutsPerWeek")
        UserDefaults.standard.set(triedOtherApps, forKey: "triedOtherApps")
        
        hasCompletedOnboarding = true
    }
    
    func nextStep() {
        currentOnboardingStep += 1
    }
    
    func previousStep() {
        if currentOnboardingStep > 0 {
            currentOnboardingStep -= 1
        }
    }
    func toggleBarrier(_ barrier: String) {
        if barriers.contains(barrier) {
            barriers.removeAll { $0 == barrier }
        } else {
            barriers.append(barrier)
        }
    }
}

// Container to manage onboarding flow
struct OnboardingContainerView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            switch onboardingState.currentOnboardingStep {
            case 0:
                AnimatedTextScreen()
            case 1:
                GenderSelectionScreen()
            case 2:
                WorkoutFrequencyScreen()
            case 3:
                OtherAppsScreen()
            case 4:
                AIResultsScreen()
            case 5:
                WeightLossSpeedScreen()
            case 6:
                AIComparison()
            case 7:
                BarriersSelectionScreen()
            case 8:
                RatingScreen()
            case 9:
                IntegrationScreen()
            case 10:
                FinalOnboardingScreen()
            default:
                Text("Error: Invalid Onboarding Step")
            }
        }
    }
}

// Your existing animated text screen
struct AnimatedTextScreen: View {
    @EnvironmentObject var onboardingState: OnboardingState
    
    // Original text content
    let words = ["It's", "You", "vs", "You."]
    @State private var visibleWords = [false, false, false, false]
    @State private var showPrice = false
    @State private var showButton = false
    
    var body: some View {
        ZStack {
            // Black background
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Spacer() // Push content to bottom half
                
                // Text container - positioned in bottom left
                VStack(alignment: .leading, spacing: 16) {
                    // Animated words
                    HStack(spacing: 8) {
                        ForEach(0..<words.count, id: \.self) { index in
                            Text(words[index])
                                .font(.system(size: 42, weight: .bold))
                                .foregroundColor(.white)
                                .opacity(visibleWords[index] ? 1.0 : 0.0)
                                .animation(.easeInOut(duration: 0.5), value: visibleWords[index])
                        }
                    }
                    
                    // Price text
                    Text("From € 5,49 per month")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .opacity(showPrice ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.5), value: showPrice)
                    
                    // Button
                    if showButton {
                        Button(action: {
                            onboardingState.nextStep()
                        }) {
                            HStack {
                                Image(systemName: "arrow.right")
                                Text("Try it for free")
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.black)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 20)
                            .background(
                                Capsule()
                                    .fill(Color.white)
                            )
                        }
                        .transition(.opacity)
                        .animation(.easeIn(duration: 0.5), value: showButton)
                    }
                }
                .padding(.leading, 16) // Exactly 16 pixels from the left
                .padding(.bottom, 160) // Adjust to position in the bottom left
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 80) // Space at the bottom
            }
        }
        .onAppear {
            animateWords()
        }
    }
    
    private func animateWords() {
        // Reset animation states when screen appears
        visibleWords = [false, false, false, false]
        showPrice = false
        showButton = false
        
        // Animate each word with a delay and haptic feedback
        for i in 0..<words.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.8) {
                triggerHapticFeedback() // Haptic feedback for each word
                withAnimation {
                    visibleWords[i] = true
                }
            }
        }
        
        // Show price after words
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(words.count) * 0.8) {
            withAnimation {
                showPrice = true
            }
        }
        
        // Show button at the end
        DispatchQueue.main.asyncAfter(deadline: .now() + (Double(words.count) * 0.8) + 0.5) {
            withAnimation {
                showButton = true
            }
        }
    }
    
    private func triggerHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}


