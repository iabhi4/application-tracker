import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/preferences_service.dart';

class OnboardingScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _targetController = TextEditingController();

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
              Text("Daily Application Target", style: TextStyle(fontSize: 20)),
              TextField(
                controller: _targetController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final name = _controller.text;
                  final target = int.tryParse(_targetController.text) ?? 0;
                  if (name.isNotEmpty && target > 0) {
                    await PreferencesService.saveName(name);
                    await PreferencesService.saveDailyTarget(target);
                    await PreferencesService.saveDailyRemaining(target);
                    await PreferencesService.saveLastResetDate(
                      DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    );
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                child: Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
