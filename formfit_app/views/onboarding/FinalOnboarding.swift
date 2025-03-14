//
//  FinalOnboarding.swift
//  formfit_app
//
//  Created by Salman Lartey on 05/03/2025.
//

import SwiftUI

struct FinalOnboardingScreen: View {
    @EnvironmentObject var onboardingState: OnboardingState
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                
                Text("You're Ready to Go!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Let's start your fitness journey")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button(action: {
                    onboardingState.completeOnboarding()
                }) {
                    Text("Get Started")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            Capsule()
                                .fill(Color.white)
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
            .padding()
        }
    }
}
