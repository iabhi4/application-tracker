import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/detailed_form_screen.dart';
import 'screens/detailed_list_screen.dart';
import 'services/preferences_service.dart';

void main() => runApp(MyApp());

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
