//
//  HomeScreen.swift
//  formfit_app
//
//  Created by Salman Lartey on 05/03/2025.
//
import SwiftUI

struct WorkoutsScreen: View {
    @State private var showingAddWorkoutSheet = false
    
    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("Workouts")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Filter button
                    Button(action: {
                        // Show filter options
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                    }
                    
                    // Add button
                    Button(action: {
                        showingAddWorkoutSheet = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 22))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Empty state workout card
                // Empty state workout card
                HStack {
                    Button(action: {
                        showingAddWorkoutSheet = true
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "#1A1A1A"))
                                .frame(width: 160, height: 160)
                            
                            Image(systemName: "plus")
                                .foregroundColor(.gray)
                                .font(.system(size: 44, weight: .light))
                        }
                    }
                    .padding(.leading, 20) // Add padding from the left edge
                    
                    Spacer() // Push the content to the left
                }
                .padding(.top, 20)
                
                Spacer()
                
                
            }
        }
        .sheet(isPresented: $showingAddWorkoutSheet) {
            WorkoutCategoryView()
        }
    }
}

// Helper for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Mock Add Workout View


struct WorkoutsScreen_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsScreen()
    }
}
