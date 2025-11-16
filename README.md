# KonbitWorks - TravayGig Marketplace

![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue)
![License](https://img.shields.io/badge/License-MIT-green)

**Travay Gig pou Ayisyen** - A modern marketplace app for gig work serving the Haitian community.

## 🌟 Features

- **User Authentication** - Secure email/password signup and login with Supabase Auth
- **Password Reset** - Forgot password functionality with email-based reset
- **Gig Marketplace** - Browse, create, edit, and delete job postings
- **Interactive Map** - Google Maps integration with custom markers showing all available gigs
- **Location Services** - Post gigs with your current location or select a location on the map
- **User Profiles** - Manage your profile and view your posted gigs
- **Offline Support** - Local caching with Hive for offline browsing
- **Real-time Updates** - Live updates when new gigs are posted
- **Responsive Design** - Material 3 design with smooth animations
- **Bilingual** - Interface in Haitian Creole (Kreyòl) and English

## 📱 Screenshots

*[Screenshots to be added]*

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                   # Core utilities and configurations
│   ├── config/            # Environment configuration
│   ├── constants/         # App-wide constants
│   ├── errors/            # Error handling
│   ├── theme/             # App theming
│   └── utils/             # Utility functions
├── data/                  # Data layer
│   ├── datasources/       # Remote and local data sources
│   ├── models/            # Data models (DTOs)
│   └── repositories/      # Repository implementations
├── domain/                # Domain layer
│   ├── entities/          # Business entities
│   └── repositories/      # Repository interfaces
└── presentation/          # Presentation layer
    ├── providers/         # Riverpod state management
    ├── router/            # GoRouter navigation
    ├── screens/           # UI screens
    └── widgets/           # Reusable widgets
```

### Tech Stack

**Frontend:**
- **Framework:** Flutter 3.0+
- **State Management:** Riverpod 2.4+
- **Navigation:** GoRouter 13.0+
- **Local Storage:** Hive 2.2+
- **Animations:** Flutter Animate 4.3+

**Backend:**
- **BaaS:** Supabase (Auth, Database, Storage)
- **Database:** PostgreSQL with Row Level Security (RLS)
- **Storage:** Supabase Storage for avatars and images

**Maps & Location:**
- **Maps:** Google Maps Flutter
- **Geolocation:** Geolocator
- **Geocoding:** Geocoding package

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / Xcode for mobile development
- A Supabase account
- Google Maps API keys
- Node.js and npm (for the landing page)

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/travaygig.git
cd travaygig
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Set Up Supabase

1. Create a new project at [Supabase](https://supabase.com)
2. Go to Project Settings > API
3. Copy your `Project URL` and `anon/public` API key
4. In the SQL Editor, run the schema from `supabase/schema.sql`

### 4. Configure Environment Variables

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and add your credentials:
   ```bash
   SUPABASE_URL=https://your-project-url.supabase.co
   SUPABASE_ANON_KEY=your-anon-key-here
   GOOGLE_MAPS_API_KEY_ANDROID=your-android-key
   GOOGLE_MAPS_API_KEY_IOS=your-ios-key
   GOOGLE_MAPS_API_KEY_WEB=your-web-key
   ENVIRONMENT=dev
   ```

### 5. Set Up Google Maps

Follow the detailed guide in [GOOGLE_MAPS_SETUP.md](GOOGLE_MAPS_SETUP.md)

Quick summary:
1. Enable Maps SDK for Android, iOS, and JavaScript API in Google Cloud Console
2. Create three separate API keys (Android, iOS, Web)
3. Configure restrictions for each platform
4. Add keys to your `.env` file

**Android:** Update `android/app/src/main/AndroidManifest.xml` with your API key

**iOS:** Update `ios/Runner/Info.plist` with your API key

**Web:** Update `web/index.html` with your API key

### 6. Generate Code

Generate necessary code for Freezed, JSON Serializable, and Hive:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 7. Run the App

```bash
# Run on Android
flutter run -d android

# Run on iOS
flutter run -d ios

# Run on Web
flutter run -d chrome --web-renderer html
```

## 🗄️ Database Setup

### Running the SQL Schema

1. Go to your Supabase project dashboard
2. Navigate to **SQL Editor**
3. Click **New Query**
4. Copy the contents of `supabase/schema.sql`
5. Paste and run the query

This creates:
- `profiles` table - User profiles
- `gigs` table - Job postings
- RLS policies for security
- Database triggers
- Storage buckets for images
- Helper functions for search and nearby gigs

### Tables

**profiles**
- `id` (UUID, Primary Key, references auth.users)
- `email` (TEXT, Unique)
- `full_name` (TEXT)
- `avatar_url` (TEXT, nullable)
- `created_at` (TIMESTAMPTZ)
- `updated_at` (TIMESTAMPTZ, nullable)

**gigs**
- `id` (UUID, Primary Key)
- `user_id` (UUID, Foreign Key to profiles)
- `title` (TEXT, 3-100 characters)
- `description` (TEXT, 10-1000 characters)
- `price` (NUMERIC, >= 0)
- `latitude` (DOUBLE PRECISION)
- `longitude` (DOUBLE PRECISION)
- `location_name` (TEXT, nullable)
- `created_at` (TIMESTAMPTZ)
- `updated_at` (TIMESTAMPTZ, nullable)

## 🔐 Security

### Row Level Security (RLS)

All tables have RLS enabled with the following policies:

**Profiles:**
- SELECT: Public (anyone can view profiles)
- INSERT: Authenticated users can create their own profile
- UPDATE: Users can only update their own profile

**Gigs:**
- SELECT: Public (anyone can view gigs)
- INSERT: Authenticated users can create gigs
- UPDATE: Users can only update their own gigs
- DELETE: Users can only delete their own gigs

### API Key Security

- **Never commit** `.env` files to version control
- Use environment variables in production
- Restrict API keys in Google Cloud Console
- Monitor usage and set up billing alerts

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 📦 Building for Production

### Android (APK)

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android (App Bundle)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS

```bash
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode and archive.

### Web

```bash
flutter build web --release --web-renderer html
```

Output: `build/web/`

Deploy to:
- Firebase Hosting
- Netlify
- Vercel
- AWS S3 + CloudFront

## 🌐 Landing Page

The landing page is built with **Next.js 14** and **Tailwind CSS**.

### Setup

```bash
cd landing-page
npm install
```

### Development

```bash
npm run dev
```

Visit http://localhost:3000

### Build

```bash
npm run build
npm start
```

### Deploy

Deploy to Vercel (recommended):

```bash
npm install -g vercel
vercel
```

Or deploy to:
- Netlify
- AWS Amplify
- Google Cloud Run

## 📚 Project Structure

### Key Files

- `lib/main.dart` - App entry point
- `lib/presentation/router/app_router.dart` - Navigation configuration
- `lib/presentation/providers/` - Riverpod providers for state management
- `lib/data/datasources/` - Supabase and Hive data sources
- `lib/domain/entities/` - Core business entities
- `supabase/schema.sql` - Complete database schema

### Configuration Files

- `pubspec.yaml` - Flutter dependencies
- `.env.example` - Environment variable template
- `android/app/src/main/AndroidManifest.xml` - Android configuration
- `ios/Runner/Info.plist` - iOS configuration
- `web/index.html` - Web configuration

## 🔧 Troubleshooting

### Common Issues

**Issue:** "MissingPluginException"
**Solution:** Run `flutter clean && flutter pub get` and rebuild

**Issue:** Maps not showing on Android
**Solution:**
- Verify API key in AndroidManifest.xml
- Check SHA-1 certificate fingerprint
- Ensure Maps SDK for Android is enabled

**Issue:** "Failed to load network image"
**Solution:** Check Supabase Storage bucket policies and internet connectivity

**Issue:** Build runner fails
**Solution:** Delete conflicting outputs: `flutter pub run build_runner build --delete-conflicting-outputs`

**Issue:** Location permission denied
**Solution:** Check AndroidManifest.xml and Info.plist have location permissions

## 📖 API Documentation

### Supabase Functions

**search_gigs(search_query TEXT)**
- Searches gigs by title or description
- Returns matching gigs ordered by creation date

**get_nearby_gigs(user_lat, user_lon, radius_km)**
- Returns gigs within specified radius
- Uses Haversine formula for distance calculation

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Write tests for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- Your Name - Initial work - [YourGitHub](https://github.com/yourusername)

## 🙏 Acknowledgments

- Haitian community for inspiration
- Flutter team for the amazing framework
- Supabase for the backend infrastructure
- Google Maps for location services

## 📞 Support

For support:
- Email: support@konbitworks.com
- GitHub Issues: [Create an issue](https://github.com/yourusername/travaygig/issues)
- Documentation: [Wiki](https://github.com/yourusername/travaygig/wiki)

## 🗺️ Roadmap

- [ ] In-app messaging between users
- [ ] Rating and review system
- [ ] Payment integration
- [ ] Push notifications
- [ ] Advanced search filters
- [ ] Multi-language support expansion
- [ ] Dark mode
- [ ] Social media sharing
- [ ] Analytics dashboard

---

**Made with ❤️ for the Haitian community**
