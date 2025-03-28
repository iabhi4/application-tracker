import 'package:application_tracker/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/detailed_form_screen.dart';
import 'screens/detailed_list_screen.dart';
import 'services/preferences_service.dart';
import 'screens/stats_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<Widget> _getLandingPage() async {
    final name = await PreferencesService.getName();
    return name == null ? OnboardingScreen() : HomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Tracker',
      routes: {
        '/home': (_) => HomeScreen(),
        '/form': (_) => DetailedFormScreen(),
        '/list': (_) => DetailedListScreen(),
        '/stats': (_) => StatsScreen(),
      },
      home: FutureBuilder(
        future: _getLandingPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data!;
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
