import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

class OnboardingScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  void _submitName(BuildContext context) async {
    if (_controller.text.isNotEmpty) {
      await PreferencesService.saveName(_controller.text);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("What's your name?", style: TextStyle(fontSize: 24)),
              TextField(controller: _controller),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitName(context),
                child: Text("Continue"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
