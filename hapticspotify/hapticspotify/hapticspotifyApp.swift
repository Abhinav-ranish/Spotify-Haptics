//
//  hapticspotifyApp.swift
//  hapticspotify
//
//  Created by John Doe on 11/4/24.
//

import SwiftUI

@main
struct hapticspotifyApp: App {
    // Attach AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

