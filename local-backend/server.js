require('dotenv').config();
const express = require('express');
const axios = require('axios');
const querystring = require('querystring');
const app = express();
const port = 3000;

const clientId = '';
const clientSecret = '';
const redirectUri = 'http://localip:3000/callback';

// Step 1: Redirect the user to Spotify’s authorization page
app.get('/login', (req, res) => {
    const scope = 'user-read-private user-read-email app-remote-control';
    const authUrl = `https://accounts.spotify.com/authorize?${querystring.stringify({
        response_type: 'code',
        client_id: clientId,
        scope: scope,
        redirect_uri: redirectUri,
    })}`;
    res.redirect(authUrl);
});

// Step 2: Handle Spotify's redirect to /callback with an authorization code
app.get('/callback', async (req, res) => {
    const code = req.query.code || null;

    if (!code) {
        res.send('Authorization failed');
        return;
    }

    try {
        // Exchange the authorization code for an access token
        const response = await axios.post('https://accounts.spotify.com/api/token', querystring.stringify({
            grant_type: 'authorization_code',
            code: code,
            redirect_uri: redirectUri,
            client_id: clientId,
            client_secret: clientSecret,
        }), {
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
        });

        const { access_token, refresh_token } = response.data;
        
        // Redirect back to the iOS app with the access token and refresh token in the URL
        res.redirect(`hapticspotify://callback?access_token=${access_token}&refresh_token=${refresh_token}`);
    } catch (error) {
        console.error('Error exchanging code for token:', error);
        res.status(500).send('Error exchanging code for token');
    }
});


// Test route
app.get('/', (req, res) => {
    res.send('Spotify Auth Backend is running');
});

// Start the server
app.listen(port, () => {
    console.log(`Server running at http://localip:${port}`);
});
