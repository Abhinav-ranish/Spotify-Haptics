//
//  AppDelegate.swift
//  hapticspotify
//
//  Created by John Doe on 11/4/24.
//
import UIKit
import SpotifyiOS

class AppDelegate: UIResponder, UIApplicationDelegate, SPTSessionManagerDelegate {
    var window: UIWindow?
    var spotifySessionManager: SPTSessionManager!
    
    override init() {
        super.init()
        
        let clientID = "YOUR_CLIENT"
        
        // Update the redirect URL to use the custom URL scheme, not the backend's callback URL
        let redirectURL = URL(string: "hapticspotify://callback")!
        
        let configuration = SPTConfiguration(clientID: clientID, redirectURL: redirectURL)
        self.spotifySessionManager = SPTSessionManager(configuration: configuration, delegate: nil)
        
        // Set the delegate
        self.spotifySessionManager.delegate = self
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("AppDelegate received URL: \(url.absoluteString)") // Debug statement
        
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
           components.scheme == "hapticspotify",
           components.host == "callback" {
            
            print("URL scheme and host matched") // Debug statement
            
            var accessToken: String?
            var refreshToken: String?

            for queryItem in components.queryItems ?? [] {
                if queryItem.name == "access_token" {
                    accessToken = queryItem.value
                } else if queryItem.name == "refresh_token" {
                    refreshToken = queryItem.value
                }
            }

            print("Access Token: \(accessToken ?? "No Access Token")")
            print("Refresh Token: \(refreshToken ?? "No Refresh Token")")
            
            return true
        }
        
        print("URL scheme or host did not match") // Debug statement if URL isn't recognized
        return false
    }


    // SPTSessionManagerDelegate methods
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("Spotify session initiated successfully!")
        print("Access Token: \(session.accessToken)") // Print access token for verification
    }

    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("Failed to initiate Spotify session: \(error.localizedDescription)")
    }
}
