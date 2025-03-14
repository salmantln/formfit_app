//
//  formfit_appApp.swift
//  formfit_app
//
//  Created by Salman Lartey on 05/03/2025.
//

import SwiftUI

//@main
//struct formfit_appApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}

@main
struct formfit_appApp: App {
    @StateObject private var onboardingState = OnboardingState()
    
    var body: some Scene {
        WindowGroup {
            if onboardingState.hasCompletedOnboarding {
                MainAppView()
                    .environmentObject(onboardingState)
            } else {
                OnboardingContainerView()
                    .environmentObject(onboardingState)
            }
        }
    }
}
