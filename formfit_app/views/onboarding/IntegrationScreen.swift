//
//  HealthScreen.swift
//  formfit_app
//
//  Created by Salman Lartey on 12/03/2025.
//

//
//  IntegrationScreen.swift
//  formfit_app
//
//  Created by Salman Lartey on 12/03/2025.
//

import SwiftUI

struct IntegrationScreen: View {
    @EnvironmentObject var onboardingState: OnboardingState
    
    // State for tracking which integrations are selected
    @State private var appleHealthConnected = false
    @State private var whoopConnected = false
    @State private var fitbitConnected = false
    @State private var garminConnected = false
    
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
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Connect your devices")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.top, 24)
                    
                    Text("Link your fitness trackers to get personalized recommendations based on your activity data.")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .padding(.bottom, 16)
                    
                    // Apple Health Integration
                    IntegrationCard(
                        title: "Apple Health",
                        description: "Sync your workouts, steps, heart rate and sleep data",
                        icon: "heart.fill",
                        iconColor: .green,
                        isConnected: $appleHealthConnected
                    )
                    
                    // WHOOP Integration
                    IntegrationCard(
                        title: "WHOOP",
                        description: "Connect your WHOOP strap for recovery and strain metrics",
                        icon: "waveform.path.ecg",
                        iconColor: .black,
                        isConnected: $whoopConnected
                    )
                    
                    // Fitbit Integration
                    IntegrationCard(
                        title: "Fitbit",
                        description: "Import data from your Fitbit device",
                        icon: "figure.walk",
                        iconColor: .blue,
                        isConnected: $fitbitConnected
                    )
                    
                    // Garmin Integration
                    IntegrationCard(
                        title: "Garmin",
                        description: "Sync with your Garmin device",
                        icon: "clock",
                        iconColor: .red,
                        isConnected: $garminConnected
                    )
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Why connect your devices?")
                            .font(.system(size: 18, weight: .semibold))
                            .padding(.top, 16)
                        
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 16))
                                .frame(width: 24, height: 24)
                            
                            Text("More accurate activity tracking")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 8)
                        
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 16))
                                .frame(width: 24, height: 24)
                            
                            Text("Personalized workout recommendations")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 4)
                        
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 16))
                                .frame(width: 24, height: 24)
                            
                            Text("Better recovery insights")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 4)
                    }
                    .padding(.vertical, 8)
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
            
            // Next button
            Button(action: {
                // Store connection state in onboarding state
                onboardingState.healthKitConnected = appleHealthConnected
                onboardingState.whoopConnected = whoopConnected
                onboardingState.nextStep()
            }) {
                Text(isAnyDeviceConnected() ? "Continue" : "Skip for now")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(isAnyDeviceConnected() ? Color.black : Color.gray)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
    }
    
    // Helper function to check if any device is connected
    private func isAnyDeviceConnected() -> Bool {
        return appleHealthConnected || whoopConnected || fitbitConnected || garminConnected
    }
}

// Integration card component
struct IntegrationCard: View {
    let title: String
    let description: String
    let icon: String
    let iconColor: Color
    @Binding var isConnected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.system(size: 20))
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Connect button
            Button(action: {
                connectToggle()
            }) {
                HStack(spacing: 4) {
                    if isConnected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                        Text("Connected")
                            .font(.system(size: 14, weight: .medium))
                    } else {
                        Text("Connect")
                            .font(.system(size: 14, weight: .medium))
                    }
                }
                .foregroundColor(isConnected ? .white : .black)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isConnected ? Color.green : Color.gray.opacity(0.2))
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .padding(.vertical, 6)
    }
    
    // Handle connect/disconnect logic
    private func connectToggle() {
        if !isConnected {
            // In a real app, you would request permission here
            // For Apple Health you would use HKHealthStore.requestAuthorization
            // For WHOOP you would use their API/SDK
            
            // For demo purposes, we'll just toggle the state
            isConnected.toggle()
        } else {
            // Show disconnect confirmation
            isConnected.toggle()
        }
    }
}

// Preview provider for SwiftUI canvas
struct IntegrationScreen_Previews: PreviewProvider {
    static var previews: some View {
        IntegrationScreen()
            .environmentObject(OnboardingState())
    }
}

// Assume this is the structure of OnboardingState
// Add these properties to your actual OnboardingState class
extension OnboardingState {
    var healthKitConnected: Bool {
        get { self.getProperty("healthKitConnected") as? Bool ?? false }
        set { self.setProperty("healthKitConnected", value: newValue) }
    }
    
    var whoopConnected: Bool {
        get { self.getProperty("whoopConnected") as? Bool ?? false }
        set { self.setProperty("whoopConnected", value: newValue) }
    }
    
    // Helper methods (implement these in your actual OnboardingState)
    private func getProperty(_ key: String) -> Any? {
        // This would access your actual storage mechanism
        return UserDefaults.standard.object(forKey: key)
    }
    
    private func setProperty(_ key: String, value: Any) {
        // This would update your actual storage mechanism
        UserDefaults.standard.set(value, forKey: key)
    }
}
