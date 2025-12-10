# KidsZikrApp

A Flutter application designed for kids to learn and practice Islamic Azkar (remembrances) with an engaging reward system.

## Features

### Core Functionality
- **Daily Zikr Tasks**: Random selection of Azkar for daily practice
- **Interactive Counter**: Tap-to-count interface for tracking progress
- **Reward System**: Earn stars and grow a virtual plant (Seed → Plant → Tree)
- **Audio Playback**: Optional audio support for learning correct pronunciation
- **Push Notifications**: Daily reminders to complete Zikr tasks
- **Progress Tracking**: Persistent storage of achievements and progress

### Architecture
- **MVVM Pattern**: Clean separation of concerns with View, ViewModel, and Services
- **State Management**: Provider package for reactive state updates
- **Service Layer**: Modular services for notifications, audio, and rewards

## Project Structure

```
lib/
├── core/                    # Core utilities and constants
├── models/                  # Data models
│   ├── task_model.dart     # Zikr task model
│   └── reward_model.dart   # Reward system model
├── services/               # Business logic services
│   ├── notification_service.dart  # Local notifications
│   ├── audio_service.dart        # Audio playback
│   ├── reward_service.dart       # Rewards and persistence
│   └── task_repository.dart      # Task data management
├── viewmodels/            # ViewModels for screens
│   ├── home_viewmodel.dart
│   └── task_viewmodel.dart
├── views/                 # UI screens
│   ├── home_screen.dart
│   └── task_screen.dart
└── main.dart             # App entry point
```

## Dependencies

- **provider**: State management
- **audioplayers**: Audio playback functionality
- **flutter_local_notifications**: Local notification support
- **timezone**: Timezone support for scheduled notifications
- **shared_preferences**: Local data persistence

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone https://github.com/MennaSrour/Clothes-Suggester.git
cd Clothes-Suggester
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Usage

### Home Screen
- View your current plant growth progress
- See today's Zikr task
- Check your total stars and completed tasks
- Start a new task or generate a different one

### Task Screen
- View the Zikr text in Arabic
- Tap the counter button to increment count
- Track progress with visual indicators
- Play audio pronunciation (when available)
- Complete the task to earn stars

### Reward System
- Earn 5 stars for each completed task
- Plant growth stages:
  - 🌱 Seed: 0-9 stars
  - 🪴 Plant: 10-29 stars
  - 🌳 Tree: 30+ stars

## Available Azkar

The app includes 12 commonly recited Azkar:
1. سُبْحَانَ اللَّهِ (33 times)
2. الْحَمْدُ لِلَّهِ (33 times)
3. اللَّهُ أَكْبَرُ (34 times)
4. لَا إِلَٰهَ إِلَّا اللَّهُ (10 times)
5. أَسْتَغْفِرُ اللَّهَ (100 times)
6. And more...

## Development

### Running Tests
```bash
flutter test
```

### Building for Production
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Acknowledgments

- Islamic Azkar content is based on authentic sources
- Built with Flutter and the Provider package
- Designed with kids in mind for an engaging learning experience