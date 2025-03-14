//
//  Main.swift
//  formfit_app
//
//  Created by Salman Lartey on 06/03/2025.
//

import SwiftUI

struct MainAppView: View {
    var body: some View {
        TabView {
            WorkoutsScreen()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            PoseView()
                .tabItem {
                    Image(systemName: "figure.walk")
                    Text("Workouts")
                }
            
            ActivityView()
                .tabItem {
                    Image(systemName: "figure.walk")
                    Text("Activity")
                }
            
            FindFriendsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Friends")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}
