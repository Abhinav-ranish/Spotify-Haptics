# Haptic Spotify (Development)

**Note**: This project is a work in progress and currently has known issues and errors. It is not fully functional yet.

HapticSpotify is an iOS app that aims to integrate with Spotify to provide a sound haptic system for Apple devices. The app allows users to log in with Spotify, access playback information, and experience haptic feedback synchronized with their music.

## Features (Planned)

- **Spotify Authentication**: Securely log in with your Spotify account.
- **Haptic Feedback**: Experience haptic feedback in sync with your Spotify music.
- **Custom Backend**: Uses a custom backend server to handle Spotify OAuth for improved security.

## Prerequisites

- **Spotify Developer Account**: Create a Spotify app at the [Spotify Developer Dashboard](https://developer.spotify.com/dashboard/applications) to obtain your client ID and client secret.
- **Node.js**: Install [Node.js](https://nodejs.org/) to run the backend server.
- **Xcode**: Required for iOS development.

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/Abhinav-ranish/Spotify-Haptics.git
cd Spotify Haptics
```

### 2. Backend Setup

The backend server is required to handle Spotify OAuth and securely store the client secret.

1. Navigate to the `backend` directory:

   ```bash
   cd backend
   ```

2. Install the required packages:

   ```bash
   npm install
   ```

3. Create a `.env` file in the `backend` directory with the following content:

   ```plaintext
   SPOTIFY_CLIENT_ID=your_spotify_client_id
   SPOTIFY_CLIENT_SECRET=your_spotify_client_secret
   SPOTIFY_REDIRECT_URI=http://localhost:3000/callback
   ```

4. Start the backend server:

   ```bash
   node server.js
   ```

   The backend server will be available at `http://localhost:3000`.

### 3. iOS App Setup

1. Open `hapticspotify.xcodeproj` in Xcode.
2. In the **Info.plist** file:
   - Add a URL type with the URL scheme `hapticspotify`.
   - This should match the custom scheme used for redirecting from the backend.
3. In `AppDelegate.swift`, verify the redirect URI handling code:
   - Ensure `application(_:open:options:)` parses the access token and refresh token from the redirect URL.
4. Update the **client ID** and **redirect URI** in `AppDelegate` to match the values used on the backend.

### 4. Running the App

1. Make sure the backend server is running.
2. Run the app in Xcode on a simulator or device.
3. Tap "Login with Spotify" to initiate the Spotify OAuth flow.
4. After logging in and authorizing the app, the app should receive an access token (but may not yet due to known issues).

## Known Issues

- **Build Errors**: There are issues with duplicate resources and missing files in Xcode, which may cause build failures.
- **URL Handling**: The app does not reliably process the redirect from the backend after Spotify login. The app may open but fail to process the access token and refresh token due to issues with the `application(_:open:options:)` method in `AppDelegate`.
- **Incomplete Haptic Integration**: Haptic feedback for Spotify playback is not fully implemented and may not work as expected.

## Troubleshooting

- **Build Input File Not Found**: Ensure all required files are correctly referenced in Xcode’s **Build Phases**.
- **Multiple Commands Produce**: Remove duplicate `Info.plist` or other resource files in **Copy Bundle Resources** under **Build Phases**.
- **Redirect Not Working**: Make sure that `Info.plist` has the correct URL scheme configured (e.g., `hapticspotify`), and that the backend is redirecting to `hapticspotify://callback`.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
