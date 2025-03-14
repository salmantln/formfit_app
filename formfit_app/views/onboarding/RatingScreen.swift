//
//  RatingScreen.swift
//  formfit_app
//
//  Created by Salman Lartey on 05/03/2025.
//

import SwiftUI

struct RatingScreen: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var rating: Int = 0
    
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
                    .frame(width: 120, height: 4)
                    .foregroundColor(.black)
                
                Rectangle()
                    .frame(width: 16, height: 4)
                    .foregroundColor(.gray.opacity(0.3))
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Rating section
                    Text("Give us rating")
                        .font(.system(size: 28, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 24)
                    
                    // Star rating
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 80)
                        
                        HStack(spacing: 8) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 32))
                                    .onTapGesture {
                                        rating = star
                                    }
                            }
                        }
                    }
                    
                    // "Made for people like you" section
                    VStack(alignment: .center, spacing: 16) {
                        Text("FormFit was made for\npeople like you")
                            .font(.system(size: 24, weight: .bold))
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: -15) {
                            // Profile images
                            ForEach(1...3, id: \.self) { _ in
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                            }
                        }
                        
                        Text("+ 1000 FormFit people")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 24)
                    
                    // Testimonial 1
                    TestimonialView(
                        name: "Marley Bryle",
                        rating: 5,
                        text: "I lost 15 lbs in 2 months! I was about to go on Ozempic but decided to give this app a shot and it worked :)"
                    )
                    
                    // Testimonial 2
                    TestimonialView(
                        name: "Benny Marcs",
                        rating: 5,
                        text: ""
                    )
                }
                .padding(.horizontal, 20)
            }
            
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
                            .fill(rating > 0 ? Color.black : Color.gray)
                    )
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
            }
            .disabled(rating == 0)
        }
    }
}

// Testimonial component
struct TestimonialView: View {
    let name: String
    let rating: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Profile image
            Circle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                // Name and rating
                HStack {
                    Text(name)
                        .font(.system(size: 16, weight: .medium))
                    
                    Spacer()
                    
                    // Star rating
                    HStack(spacing: 2) {
                        ForEach(1...rating, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 12))
                        }
                    }
                }
                
                // Review text
                if !text.isEmpty {
                    Text(text)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.2))
        )
    }
}

struct RatingScreen_Previews: PreviewProvider {
    static var previews: some View {
        RatingScreen()
            .environmentObject(OnboardingState())
    }
}
