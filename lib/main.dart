import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/app_provider.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const PitchMasterApp());
}

class PitchMasterApp extends StatelessWidget {
  const PitchMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp(
            title: 'PitchMaster AI',
            debugShowCheckedModeBanner: false,
            theme: appProvider.getTheme(),
            home: const WelcomeScreen(),
            routes: {
              '/home': (context) => const HomeScreen(),
              '/welcome': (context) => const WelcomeScreen(),
            },
          );
        },
      ),
    );
  }
}
