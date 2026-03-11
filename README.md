# RACIPAY — Mobile Billing & Payment App

## About
RACIPAY is a Flutter mobile application for Racitelcom Internet Services. It allows subscribers to view bills, pay via PayMongo, and submit support tickets. Linemen can manage assigned service tickets in the field.

## Demo Credentials
| Role       | Email                          | Password    |
|------------|-------------------------------|-------------|
| Subscriber | subscriber@racitelcom.com     | password123 |
| Lineman    | lineman@racitelcom.com        | password123 |

## Tech Stack
- Flutter + Dart
- Material 3
- GoRouter (navigation)
- Riverpod (state management)
- Google Fonts (Inter)
- Shimmer (loading states)

## How to Run
1. Make sure Flutter SDK is installed
2. Clone or unzip the project
3. Run: `flutter pub get`
4. Run: `flutter run`
5. Select your Android device or emulator

## Project Structure
`lib/`
- `core/`
  - `constants/` → `app_colors.dart`, `app_strings.dart`
  - `models/` → all data models
  - `router/` → `app_router.dart`
  - `theme/` → `app_theme.dart`
  - `utils/` → `formatters.dart`
- `mock/` → `mock_data.dart`
- `screens/`
  - `auth/` → splash, login, forgot password
  - `subscriber/` → all subscriber screens
  - `lineman/` → all lineman screens
- `shared/`
  - `widgets/` → reusable components
- `main.dart`

## Current Status
- UI complete with mock data
- No real backend connected yet
- PayMongo is placeholder UI
- Ready for backend integration

