import 'package:flutter/material.dart';
import '../models/application.dart';

class DetailedViewScreen extends StatelessWidget {
  final Application application;

  const DetailedViewScreen({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(application.companyName)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Position: ${application.position}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Location: ${application.location}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Applied On: ${application.dateApplied}",
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
