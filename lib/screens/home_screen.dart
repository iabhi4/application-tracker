import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../models/application.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = '';
  int count = 0;
  List<Application> applications = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    name = (await PreferencesService.getName()) ?? '';
    count = await PreferencesService.getCount();
    applications = await PreferencesService.getApplications();
    setState(() {});
  }

  Future<void> _addCount({Application? app}) async {
    setState(() {
      count++;
    });
    if (app != null) {
      applications.add(app);
      await PreferencesService.saveApplications(applications);
    }
    await PreferencesService.saveCount(count);
  }

  void _resetData() async {
    await PreferencesService.clearAll();
    Navigator.pushReplacementNamed(context, '/');
  }

  void _reduceCount() async {
    if (count > 0) {
      setState(() {
        count--;
      });
      await PreferencesService.saveCount(count);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Count is already at zero.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hi, ${name.split(' ').first}"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'reset') _resetData();
              if (value == 'view') Navigator.pushNamed(context, '/list');
              if (value == 'reduce') _reduceCount();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 'view', child: Text('View Detailed Applications')),
              PopupMenuItem(value: 'reduce', child: Text('Reduce Count')),
              PopupMenuItem(value: 'reset', child: Text('Reset All')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "You have applied to $count positions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 40),

            // BIG Circular Quick Add Button
            GestureDetector(
              onTap: () {
                setState(() {
                  count++;
                });
                PreferencesService.saveCount(count);
              },
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple,
                ),
                child: Icon(Icons.add, color: Colors.white, size: 36),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Quick Add",
              style: TextStyle(fontSize: 16, color: Colors.deepPurple),
            ),

            SizedBox(height: 30),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade400)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text("or", style: TextStyle(color: Colors.grey)),
                ),
                Expanded(child: Divider(color: Colors.grey.shade400)),
              ],
            ),
            SizedBox(height: 30),

            // Detailed Entry Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade100,
                foregroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, '/form').then((value) {
                if (value is Application) _addCount(app: value);
              }),
              child: Text("Detailed Entry", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
