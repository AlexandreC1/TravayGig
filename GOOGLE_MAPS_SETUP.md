# Google Maps Configuration Guide for TravayGig

This guide explains how to configure Google Maps for Android, iOS, and Web platforms.

## Prerequisites

1. A Google Cloud Platform account
2. A project created in Google Cloud Console
3. Billing enabled on your Google Cloud project

## Step 1: Enable Google Maps APIs

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Navigate to **APIs & Services** > **Library**
4. Enable the following APIs:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**
   - **Maps JavaScript API**
   - **Geocoding API** (for address lookups)
   - **Places API** (optional, for place autocomplete)

## Step 2: Create API Keys

### Create THREE separate API keys for security:

1. **Android API Key**
   - In Cloud Console, go to **APIs & Services** > **Credentials**
   - Click **+ CREATE CREDENTIALS** > **API Key**
   - Click **Restrict Key**
   - Under "Application restrictions", select **Android apps**
   - Click **+ Add an item** and enter:
     - Package name: `com.konbitworks.travaygig` (or your package)
     - SHA-1 certificate fingerprint: Get this by running:
       ```bash
       keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
       ```
   - Under "API restrictions", select **Restrict key**
   - Select: Maps SDK for Android, Geocoding API
   - Click **Save**
   - Copy the API key

2. **iOS API Key**
   - Create another API key
   - Under "Application restrictions", select **iOS apps**
   - Add your iOS bundle identifier: `com.konbitworks.travaygig`
   - Under "API restrictions", select: Maps SDK for iOS, Geocoding API
   - Click **Save**
   - Copy the API key

3. **Web API Key**
   - Create another API key
   - Under "Application restrictions", select **HTTP referrers**
   - Add authorized referrers:
     - `localhost:*` (for development)
     - Your production domain (e.g., `https://konbitworks.com/*`)
   - Under "API restrictions", select: Maps JavaScript API, Geocoding API
   - Click **Save**
   - Copy the API key

## Step 3: Configure Your Project

### Update .env file

```bash
# In your .env file
GOOGLE_MAPS_API_KEY_ANDROID=your-android-api-key-here
GOOGLE_MAPS_API_KEY_IOS=your-ios-api-key-here
GOOGLE_MAPS_API_KEY_WEB=your-web-api-key-here
```

### Android Configuration

The Android key is automatically loaded from the manifest. The value `${GOOGLE_MAPS_API_KEY_ANDROID}` will be replaced during build.

For Gradle-based injection, add to `android/app/build.gradle`:

```gradle
android {
    defaultConfig {
        // ... other config
        manifestPlaceholders = [
            GOOGLE_MAPS_API_KEY_ANDROID: project.findProperty('GOOGLE_MAPS_API_KEY_ANDROID') ?: ''
        ]
    }
}
```

And add to `android/gradle.properties`:
```properties
GOOGLE_MAPS_API_KEY_ANDROID=your-android-key-here
```

### iOS Configuration

1. Open `ios/Runner/Info.plist`
2. Replace `YOUR_IOS_API_KEY_HERE` with your actual iOS API key
3. Or use build configurations for better security

### Web Configuration

1. Open `web/index.html`
2. Replace `YOUR_WEB_API_KEY` with your actual Web API key in the script tag:
   ```html
   <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_WEB_API_KEY"></script>
   ```

## Step 4: Test Your Integration

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d ios
```

### Web
```bash
flutter run -d chrome --web-renderer html
```

## Security Best Practices

1. **Never commit API keys to version control**
   - Keep keys in `.env` file (which is gitignored)
   - Use environment variables in CI/CD

2. **Use API key restrictions**
   - Always restrict keys to specific platforms
   - Set up billing alerts in Google Cloud Console

3. **Monitor usage**
   - Regularly check Google Cloud Console for unusual activity
   - Set up budget alerts

4. **Production deployment**
   - For production, use build-time environment variables
   - Consider using a secret management service (e.g., AWS Secrets Manager, HashiCorp Vault)

## Troubleshooting

### Maps not showing?
- Check that the API is enabled in Google Cloud Console
- Verify the API key is correct
- Check browser/device console for error messages
- Ensure billing is enabled on your Google Cloud project

### "API key not authorized" error?
- Verify the API key restrictions match your app's package name/bundle ID
- For Android, check SHA-1 fingerprint is correct
- For Web, check HTTP referrers are configured

### Getting started location not working?
- Ensure location permissions are granted on the device
- Check Info.plist (iOS) has location usage descriptions
- Check AndroidManifest.xml has location permissions

## Cost Management

Google Maps provides $200 of free usage per month. Monitor your usage:

1. Go to Google Cloud Console > Billing
2. Set up budget alerts
3. Optimize map loads (cache markers, limit API calls)

## Additional Resources

- [Google Maps Platform Documentation](https://developers.google.com/maps/documentation)
- [Flutter Google Maps Plugin](https://pub.dev/packages/google_maps_flutter)
- [Google Cloud Console](https://console.cloud.google.com/)
