import 'package:flutter/material.dart';
import '../models/application.dart';

class ApplicationCard extends StatelessWidget {
  final Application application;
  final VoidCallback? onTap;

  const ApplicationCard({super.key, required this.application, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(application.companyName,
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${application.position} • ${application.location}"),
        trailing: Text(application.dateApplied),
        onTap: onTap,
      ),
    );
  }
}
