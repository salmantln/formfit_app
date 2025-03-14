//
//  ProfileView.swift
//  formfit_app
//
//  Created by Salman Lartey on 11/03/2025.
//

import SwiftUI

struct ProfileView: View {
    // User data
    let username = "AmaniH"
    let fullName = "Amani Hadley"
    let initials = "AH"
    
    // Stats
    let workouts = 1
    let achievements = 2
    let bestStreak = 1
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with profile and settings
                HStack(alignment: .center) {
                    // Profile avatar with initials
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.7))
                            .frame(width: 80, height: 80)
                        
                        Text(initials)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    // Name and username
                    VStack(alignment: .leading, spacing: 2) {
                        Text(username)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(fullName)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 8)
                    
                    Spacer()
                    
                    // Settings button
                    Button(action: {
                        // Handle settings tap
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                
                // Stats row
                HStack(spacing: 0) {
                    StatView(icon: "figure.walk", value: workouts, label: "Workout")
                    StatView(icon: "trophy", value: achievements, label: "Achievement")
                    StatView(icon: "flame", value: bestStreak, label: "Best Streak")
                }
                .padding(.top, 10)
                
                // Achievements section
                SectionHeader(title: "Achievements")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        AchievementBadge(
                            color: Color.blue,
                            borderColor: Color.yellow,
                            value: "20",
                            title: "Top 20%"
                        )
                        
                        AchievementBadge(
                            color: Color.green,
                            borderColor: Color.teal,
                            value: "1",
                            title: "Let's Get\nIt Started"
                        )
                        
                        AchievementBadge(
                            color: Color.gray.opacity(0.3),
                            borderColor: Color.gray,
                            icon: "arrow.up",
                            title: "Moving Up"
                        )
                        
                        AchievementBadge(
                            color: Color.gray.opacity(0.3),
                            borderColor: Color.purple,
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Progress"
                        )
                    }
                    .padding(.horizontal)
                }
                
                // Personal Records section
                SectionHeader(title: "Personal Records")
                
                VStack(spacing: 15) {
                    PersonalRecordCard(
                        medal: "gold",
                        exercise: "Reverse Lunges",
                        description: "Most reps in a row",
                        value: "17"
                    )
                    
                    PersonalRecordCard(
                        medal: "silver",
                        exercise: "Modified Push Ups",
                        description: "Highest avg. pace",
                        value: "18/m"
                    )
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(hex: "#1A1A1A").edgesIgnoringSafeArea(.all))
    }
}

// Stats item view
struct StatView: View {
    let icon: String
    let value: Int
    let label: String
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.gray)
            
            Text("\(value)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

// Section header with "See all" button
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                // Handle "See all" tap
            }) {
                Text("See all")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

// Achievement badge component
struct AchievementBadge: View {
    let color: Color
    let borderColor: Color
    var value: String? = nil
    var icon: String? = nil
    let title: String
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Badge shape
                ShieldShape()
                    .fill(color)
                    .overlay(
                        ShieldShape()
                            .stroke(borderColor, lineWidth: 2)
                    )
                    .frame(width: 60, height: 70)
                
                // Content (either value or icon)
                if let value = value {
                    Text(value)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 70)
        }
    }
}

// Shield shape for badges
struct ShieldShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Top of shield
        path.move(to: CGPoint(x: width * 0.5, y: 0))
        
        // Right curve
        path.addLine(to: CGPoint(x: width * 0.9, y: height * 0.3))
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: height),
            control1: CGPoint(x: width * 0.9, y: height * 0.7),
            control2: CGPoint(x: width * 0.6, y: height)
        )
        
        // Left curve
        path.addCurve(
            to: CGPoint(x: width * 0.1, y: height * 0.3),
            control1: CGPoint(x: width * 0.4, y: height),
            control2: CGPoint(x: width * 0.1, y: height * 0.7)
        )
        
        // Back to top
        path.addLine(to: CGPoint(x: width * 0.5, y: 0))
        
        return path
    }
}

// Personal record card component
struct PersonalRecordCard: View {
    let medal: String // "gold" or "silver"
    let exercise: String
    let description: String
    let value: String
    
    var body: some View {
        HStack {
            // Medal icon
            ZStack {
                Circle()
                    .fill(Color(hex: medal == "gold" ? "#FFD700" : "#C0C0C0"))
                    .frame(width: 40, height: 40)
                
                if medal == "gold" {
                    Text("🥇")
                        .font(.title2)
                } else {
                    Text("🥈")
                        .font(.title2)
                }
            }
            
            // Exercise details
            VStack(alignment: .leading, spacing: 2) {
                Text(exercise)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            // Value
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
        }
        .padding()
        .background(Color(hex: "#2A2A2A"))
        .cornerRadius(16)
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .preferredColorScheme(.dark)
    }
}
