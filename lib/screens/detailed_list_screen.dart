import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../models/application.dart';
import '../widgets/application_card.dart';
import 'detailed_view_screen.dart';

class DetailedListScreen extends StatelessWidget {
  Future<List<Application>> _fetchApps() =>
      PreferencesService.getApplications();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Applications")),
      body: FutureBuilder(
        future: _fetchApps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return Center(child: CircularProgressIndicator());

          final apps = snapshot.data as List<Application>;

          return ListView.builder(
            itemCount: apps.length,
            itemBuilder: (context, index) {
              final app = apps[index];
              return ApplicationCard(
                application: app,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailedViewScreen(application: app),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
