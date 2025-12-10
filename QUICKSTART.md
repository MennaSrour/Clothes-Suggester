# KidsZikrApp - Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### Step 1: Prerequisites
Ensure you have Flutter installed:
```bash
flutter --version
```

If not installed, visit: https://docs.flutter.dev/get-started/install

### Step 2: Clone and Setup
```bash
# Clone the repository
git clone https://github.com/MennaSrour/Clothes-Suggester.git
cd Clothes-Suggester

# Install dependencies
flutter pub get
```

### Step 3: Run the App
```bash
# Check connected devices
flutter devices

# Run on connected device/emulator
flutter run
```

### Step 4: Build for Production
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (requires macOS)
flutter build ios --release
```

## 📁 File Overview

### Models (`lib/models/`)
- **task_model.dart**: Zikr task data structure
- **reward_model.dart**: Reward and plant growth data

### Services (`lib/services/`)
- **notification_service.dart**: Push notifications
- **audio_service.dart**: Audio playback
- **reward_service.dart**: Points and achievements
- **task_repository.dart**: Azkar database

### ViewModels (`lib/viewmodels/`)
- **home_viewmodel.dart**: Home screen logic
- **task_viewmodel.dart**: Task screen logic

### Views (`lib/views/`)
- **home_screen.dart**: Main screen UI
- **task_screen.dart**: Task completion UI

### Entry Point
- **main.dart**: App initialization and routing

## 🎯 Key Features to Test

1. **Home Screen**
   - View plant progress indicator
   - See today's random Zikr task
   - Check statistics (stars and completed tasks)
   - Tap "Start Task" button

2. **Task Screen**
   - Tap the counter button to increment
   - Watch progress bar fill up
   - Use reset/decrement if needed
   - Complete task when count reaches target
   - See success dialog with rewards

3. **Reward System**
   - Complete tasks to earn stars
   - Watch plant grow: 🌱 → 🪴 → 🌳
   - Track total achievements

## 🔧 Troubleshooting

### Issue: Dependencies not installing
```bash
flutter clean
flutter pub get
```

### Issue: Build errors
```bash
flutter doctor -v
# Follow recommendations from doctor
```

### Issue: Hot reload not working
```bash
# Press 'r' in terminal for hot reload
# Press 'R' for hot restart
```

## 📱 Platform-Specific Setup

### Android
No additional setup required! Just run:
```bash
flutter run
```

### iOS (macOS only)
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select a development team
3. Run from Xcode or use:
```bash
flutter run
```

## 🎨 Customization

### Adding New Azkar
Edit `lib/services/task_repository.dart`:
```dart
TaskModel(
  id: '13',
  text: 'Your Arabic Text',
  count: 10,
  audioPath: null,
),
```

### Changing Reward Values
Edit `lib/viewmodels/task_viewmodel.dart`:
```dart
// Change stars awarded per task
final rewards = await _rewardService.awardTaskCompletion(stars: 10);
```

### Adjusting Plant Growth Thresholds
Edit `lib/services/reward_service.dart`:
```dart
if (totalStars < 20) {        // Changed from 10
  newGrowth = 0; // Seed
} else if (totalStars < 50) { // Changed from 30
  newGrowth = 1; // Plant
} else {
  newGrowth = 2; // Tree
}
```

## 📚 Documentation

- **README.md**: Project overview
- **PROJECT_ANALYSIS.md**: Detailed technical analysis
- **Code Comments**: Inline documentation in all files

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

For issues or questions:
- Open a GitHub issue
- Check Flutter documentation: https://docs.flutter.dev
- Review Provider documentation: https://pub.dev/packages/provider

## ✅ Checklist for Development

- [ ] Flutter installed and working
- [ ] Dependencies installed (`flutter pub get`)
- [ ] App runs without errors
- [ ] Can complete a task
- [ ] Rewards are saved and persistent
- [ ] Navigation works between screens
- [ ] No console errors during testing

## 🎉 You're Ready!

The app is fully functional and ready for development or deployment. Happy coding! 🚀
