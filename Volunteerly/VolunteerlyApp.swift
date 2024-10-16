//
//  VolunteerlyApp.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 11/10/24.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct VolunteerlyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var userViewModel = UserViewModel()
    @StateObject var eventsViewModel = EventsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserViewModel())
                .environmentObject(EventsViewModel())
                .environmentObject(UserSession(userViewModel: userViewModel, eventsViewModel: eventsViewModel))
        }
    }
}
