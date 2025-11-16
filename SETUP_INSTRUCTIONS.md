# TravayGig - Complete Setup Instructions

This guide will walk you through setting up the complete TravayGig application from scratch.

## Prerequisites Checklist

- [ ] Flutter SDK 3.0+ installed
- [ ] Android Studio or Xcode installed
- [ ] Supabase account created
- [ ] Google Cloud Platform account
- [ ] Node.js and npm installed
- [ ] Git installed

## Step-by-Step Setup

### 1. Clone and Install

```bash
# Clone the repository
git clone https://github.com/yourusername/travaygig.git
cd travaygig

# Install Flutter dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Supabase Setup (15 minutes)

1. **Create Project**
   - Go to [supabase.com](https://supabase.com)
   - Click "New Project"
   - Fill in project details
   - Wait for database to be created

2. **Get API Credentials**
   - Go to Project Settings > API
   - Copy "Project URL"
   - Copy "anon/public" key
   - Save these for later

3. **Run Database Schema**
   - Go to SQL Editor
   - Click "New Query"
   - Copy contents of `supabase/schema.sql`
   - Paste and run
   - Verify tables were created in Table Editor

4. **Set Up Storage**
   - Go to Storage
   - Verify `avatars` and `gig_images` buckets exist
   - Check bucket policies are active

### 3. Google Maps Setup (20 minutes)

Follow the detailed guide in `GOOGLE_MAPS_SETUP.md`.

**Quick Steps:**
1. Create Google Cloud project
2. Enable Maps APIs (Android, iOS, JavaScript)
3. Create 3 API keys (Android, iOS, Web)
4. Restrict each key appropriately
5. Enable billing (free tier available)

### 4. Environment Configuration

1. **Create .env file**
   ```bash
   cp .env.example .env
   ```

2. **Edit .env with your credentials**
   ```bash
   # Supabase
   SUPABASE_URL=https://xxxxx.supabase.co
   SUPABASE_ANON_KEY=your-anon-key

   # Google Maps
   GOOGLE_MAPS_API_KEY_ANDROID=your-android-key
   GOOGLE_MAPS_API_KEY_IOS=your-ios-key
   GOOGLE_MAPS_API_KEY_WEB=your-web-key

   # Environment
   ENVIRONMENT=dev
   ```

### 5. Platform-Specific Configuration

**Android:**
1. Open `android/app/src/main/AndroidManifest.xml`
2. Replace `${GOOGLE_MAPS_API_KEY_ANDROID}` with your actual key
3. Update package name if needed

**iOS:**
1. Open `ios/Runner/Info.plist`
2. Replace `YOUR_IOS_API_KEY_HERE` with your actual key
3. Update bundle identifier if needed

**Web:**
1. Open `web/index.html`
2. Replace `YOUR_WEB_API_KEY` with your actual key

### 6. First Run

```bash
# Check for issues
flutter doctor

# Run on your preferred platform
flutter run -d android  # For Android
flutter run -d ios      # For iOS
flutter run -d chrome   # For Web
```

### 7. Test the App

1. **Sign Up**
   - Open the app
   - Click "Enskri" (Sign Up)
   - Enter your details
   - Verify you can create an account

2. **Create a Gig**
   - Click the "Ajoute travay" button
   - Fill in gig details
   - Select a location
   - Submit

3. **View on Map**
   - Go to the Map tab
   - Verify your gig appears
   - Test marker interaction

4. **Edit/Delete**
   - Go to Profile
   - View your gigs
   - Test editing and deleting

### 8. Landing Page Setup (Optional)

```bash
cd landing-page
npm install
npm run dev
# Open http://localhost:3000
```

## Common Setup Issues

### Flutter Doctor Issues

**Android License Not Accepted**
```bash
flutter doctor --android-licenses
```

**iOS Setup Issues**
```bash
sudo gem install cocoapods
cd ios && pod install
```

### Supabase Issues

**Schema Won't Run**
- Check you're using PostgreSQL 14+
- Run each section separately
- Check error messages in SQL Editor

### Google Maps Issues

**Maps Not Showing**
- Verify API keys are correct
- Check billing is enabled
- Ensure correct APIs are enabled
- Check API key restrictions

**Permission Denied**
- Android: Check AndroidManifest.xml has location permissions
- iOS: Check Info.plist has location usage descriptions

### Build Issues

**Code Generation Fails**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**Hive Errors**
- Make sure Hive adapter is registered in main.dart
- Check typeId is unique

## Production Deployment

### Android

```bash
# Generate signing key
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key

# Build release
flutter build appbundle --release
```

### iOS

```bash
# Build
flutter build ios --release

# Then use Xcode to archive and upload
open ios/Runner.xcworkspace
```

### Web

```bash
# Build
flutter build web --release --web-renderer html

# Deploy to Firebase
firebase init hosting
firebase deploy
```

## Next Steps

1. **Customize branding**
   - Update app name and icons
   - Modify color scheme
   - Add your logo

2. **Add features**
   - Implement in-app messaging
   - Add payment integration
   - Create rating system

3. **Deploy**
   - Set up CI/CD
   - Deploy to app stores
   - Launch marketing site

## Support

- Check `README.md` for detailed documentation
- See `GOOGLE_MAPS_SETUP.md` for maps configuration
- Create GitHub issues for bugs
- Email support@konbitworks.com

## Congratulations! 🎉

You've successfully set up TravayGig. Start building amazing features for the community!
