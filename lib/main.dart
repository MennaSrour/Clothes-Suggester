import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/task_viewmodel.dart';
import 'views/home_screen.dart';

/// Main entry point of the Kids Zikr App
void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const KidsZikrApp());
}

/// Root widget of the application
class KidsZikrApp extends StatelessWidget {
  const KidsZikrApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Setup MultiProvider for state management
    return MultiProvider(
      providers: [
        // Home ViewModel Provider
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(),
        ),
        // Task ViewModel Provider
        ChangeNotifierProvider(
          create: (_) => TaskViewModel(),
        ),
      ],
      child: MaterialApp(
        // App configuration
        title: 'Kids Zikr App',
        debugShowCheckedModeBanner: false,

        // Theme configuration
        theme: ThemeData(
          // Color scheme
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
          
          // Use Material 3
          useMaterial3: true,

          // App bar theme
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 2,
          ),

          // Card theme
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          // Button theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),

          // Input decoration theme
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
          ),
        ),

        // Dark theme configuration
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 2,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
          ),
        ),

        // Theme mode
        themeMode: ThemeMode.system,

        // Initial route
        home: const HomeScreen(),

        // Route configuration
        routes: {
          '/home': (context) => const HomeScreen(),
          // TaskScreen is navigated to directly with parameters
          // using Navigator.push() in HomeScreen
        },
      ),
    );
  }
}
