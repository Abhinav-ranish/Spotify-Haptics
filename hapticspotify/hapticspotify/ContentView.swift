//
//  ContentView.swift
//  hapticspotify
//
//  Created by John Doe on 11/4/24.
//
import SwiftUI
import CoreHaptics
import SpotifyiOS

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var isHapticsOn = false
    let spotifySessionManager = (UIApplication.shared.delegate as? hapticspotify.AppDelegate)?.spotifySessionManager

    var body: some View {
        VStack {
            if isLoggedIn {
                Button(action: {
                    toggleHaptics()
                }) {
                    Text(isHapticsOn ? "Stop Haptic" : "Start Haptic")
                        .padding()
                        .background(isHapticsOn ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                Button("Login with Spotify") {
                    startSpotifyLogin()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .onAppear {
            prepareHapticEngine()
        }
    }
    
    func startSpotifyLogin() {
        print("Login button tapped") // Debugging print statement
        guard let url = URL(string: "http://localip:3000/login") else { return }
        UIApplication.shared.open(url)
    }


    func toggleHaptics() {
        if isHapticsOn {
            stopHapticFeedback()
            isHapticsOn = false
        } else {
            startHapticFeedback()
            isHapticsOn = true
        }
    }
    
    // Haptic Engine setup and methods
    @State private var engine: CHHapticEngine?

    func prepareHapticEngine() {
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Error starting haptic engine: \(error)")
        }
    }


    func startHapticFeedback() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            let hapticPattern = try CHHapticPattern(events: [
                CHHapticEvent(eventType: .hapticContinuous, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                ], relativeTime: 0, duration: 1)
            ], parameters: [])

            let player = try engine?.makePlayer(with: hapticPattern)
            try player?.start(atTime: 0)
        } catch {
            print("Error playing haptic pattern: \(error)")
        }
    }

    func stopHapticFeedback() {
        engine?.stop(completionHandler: nil)
    }
}
