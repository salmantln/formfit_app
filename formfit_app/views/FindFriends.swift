//
//  FindFriends.swift
//  formfit_app
//
//  Created by Salman Lartey on 11/03/2025.
//

import SwiftUI

struct FindFriendsView: View {
    // Model for user data
    struct UserScore: Identifiable {
        let id = UUID()
        let name: String
        let score: Int
        let image: String // In a real app, this would be a proper image source
        let isCurrentUser: Bool
    }
    
    // Sample data
    let users: [UserScore] = [
        UserScore(name: "Amritha", score: 370, image: "person.circle.fill", isCurrentUser: false),
        UserScore(name: "Nico", score: 356, image: "person.circle.fill", isCurrentUser: false),
        UserScore(name: "You", score: 348, image: "person.circle.fill", isCurrentUser: true),
        UserScore(name: "Iris", score: 319, image: "person.circle.fill", isCurrentUser: false),
        UserScore(name: "Adam", score: 278, image: "person.circle.fill", isCurrentUser: false)
    ]
    
    // Current exercise
    let exerciseName = "Squats"
    
    // Timer state
    @State private var secondsRemaining = 25
    @State private var reps = 12
    @State private var isPlaying = false
    
    // Tab selection
    @State private var selectedTab = 2
    
    var body: some View {
        ZStack {
            // Background color
            Color(hex: "#1E1E1E").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Friends")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "person.fill.badge.plus")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Phone mockup with workout screen
                ZStack {
                    // Phone frame
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.black)
                        .frame(width: 280, height: 560)
                        .overlay(
                            RoundedRectangle(cornerRadius: 36)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                        )
                    
                    // Phone notch
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black)
                        .frame(width: 120, height: 25)
                        .offset(y: -267)
                    
                    // Phone screen content
                    VStack(spacing: 0) {
                        // Leaderboard
                        VStack(spacing: 8) {
                            ForEach(Array(users.enumerated()), id: \.element.id) { index, user in
                                HStack {
                                    // Rank
                                    Text("\(index + 12)")
                                        .foregroundColor(.gray)
                                        .frame(width: 25, alignment: .leading)
                                        .font(.system(size: 14))
                                    
                                    // User image
                                    Image(systemName: user.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .background(Circle().fill(user.isCurrentUser ? Color.blue : Color.gray))
                                        .foregroundColor(.white)
                                    
                                    // Name
                                    Text(user.name)
                                        .foregroundColor(user.isCurrentUser ? .white : .gray)
                                        .font(.system(size: 14))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    // Score
                                    Text("\(user.score)")
                                        .foregroundColor(user.isCurrentUser ? .white : .gray)
                                        .fontWeight(.bold)
                                        .font(.system(size: 14))
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 36)
                                .background(user.isCurrentUser ? Color.blue.opacity(0.2) : Color.clear)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.top, 15)
                        
                        Spacer()
                        
                        // Exercise name
                        Text(exerciseName)
                            .foregroundColor(.white)
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.bottom, 10)
                        
                        // Timer and reps
                        HStack(spacing: 40) {
                            // Timer
                            VStack {
                                Text(":\(String(format: "%02d", secondsRemaining))")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("remaining")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                            
                            // Reps
                            VStack {
                                Text("\(reps)")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("reps")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                        }
                        .padding(.bottom, 20)
                        
                        // Controls
                        HStack(spacing: 30) {
                            Button(action: {}) {
                                Image(systemName: "backward.fill")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                            
                            Button(action: { isPlaying.toggle() }) {
                                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .background(Circle().fill(Color.blue))
                            }
                            
                            Button(action: {}) {
                                Image(systemName: "forward.fill")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.bottom, 30)
                        
                   
                    }
                    .frame(width: 250, height: 530)
                    .background(Color.black)
                    .cornerRadius(30)
                    
                    // Avatar bubbles
                    AvatarBubble(offsetX: -160, offsetY: -220, image: "person.circle.fill", color: .red)
                    AvatarBubble(offsetX: 160, offsetY: -220, image: "person.circle.fill", color: .blue)
                    AvatarBubble(offsetX: -160, offsetY: 0, image: "person.circle.fill", color: .cyan)
                    AvatarBubble(offsetX: 160, offsetY: 180, image: "person.circle.fill", color: .orange)
                }
                .frame(height: 560)
                .padding(.top, 10)
                
                // Did you know section
                VStack(spacing: 15) {
                    Text("Did you know?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("You're 2x more likely to stay in shape with friends! Track progress together, compete, and stay accountable.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .font(.body)
                        .padding(.horizontal, 20)
                    
                    Button(action: {}) {
                        Text("Find my friends")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.white)
                            .cornerRadius(30)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 5)
                }
                .padding(.top, 25)
                .padding(.bottom, 20)
                
         
            }
        }
    }
    

}

// Custom view for the circular avatars on the edges
struct AvatarBubble: View {
    let offsetX: CGFloat
    let offsetY: CGFloat
    let image: String
    let color: Color
    
    var body: some View {
        Image(systemName: image)
            .resizable()
            .scaledToFit()
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
            .padding(5)
            .background(Circle().fill(color))
            .offset(x: offsetX, y: offsetY)
    }
}


struct FitnessAppView_Previews: PreviewProvider {
    static var previews: some View {
        FindFriendsView()
    }
}
