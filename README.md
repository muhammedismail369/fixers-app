# Fixers App

A Flutter application for connecting users with service providers (fixers).

## Features

- Email/Password Authentication
- BLoC State Management
- Firebase Integration
- Clean and Modern UI
- Form Validation
- Error Handling
- Splash Screen with Animations

## Getting Started

### Prerequisites

- Flutter SDK (>=3.2.6)
- Dart SDK (>=3.2.6)
- Firebase Project Setup
- Android Studio / VS Code

### Installation

1. Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/fixers_app.git
```

2. Navigate to project directory:

```bash
cd fixers_app
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```

### Firebase Setup

1. Create a new Firebase project
2. Add Android app to Firebase project
3. Download `google-services.json` and place it in `android/app/`
4. Enable Email/Password authentication in Firebase Console

## Project Structure

```
lib/
├── blocs/
│   └── auth/
│       ├── auth_bloc.dart
│       ├── auth_event.dart
│       └── auth_state.dart
├── models/
├── routes/
├── screens/
│   ├── auth_screen.dart
│   ├── booking_screen.dart
│   ├── category_screen.dart
│   ├── home_screen.dart
│   ├── spash_screen.dart
│   └── worker_profile_screen.dart
├── services/
│   └── auth_service.dart
├── widgets/
└── main.dart
```

## State Management

The app uses BLoC (Business Logic Component) pattern for state management:

- **AuthBloc**: Handles authentication states and events
- **Events**: Login, Signup, Logout, etc.
- **States**: Loading, Authenticated, Unauthenticated, Error

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
