import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/preferences_service.dart';
import '../models/application.dart';
import '../services/notification_service.dart';

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
    _checkDailyReset();
    _loadData().then((_) => _scheduleReminderIfNeeded());
  }

  Future<void> _loadData() async {
    name = (await PreferencesService.getName()) ?? '';
    count = await PreferencesService.getCount();
    applications = await PreferencesService.getApplications();
    setState(() {});
  }

  Future<void> _handleNewApplication({Application? app}) async {
    setState(() {
      count++;
    });

    // Save total count
    await PreferencesService.saveCount(count);

    // Save detailed application if present
    if (app != null) {
      applications.add(app);
      await PreferencesService.saveApplications(applications);
    }

    await PreferencesService.updateTodayStat();

    // Reduce dailyRemaining
    int remaining = await PreferencesService.getDailyRemaining();
    remaining = (remaining > 0) ? remaining - 1 : 0;
    await PreferencesService.saveDailyRemaining(remaining);

    // Show Congrats dialog if target met
    if (remaining == 0) {
      final alreadyShown = await PreferencesService.getTargetReachedToday();
      if (!alreadyShown) {
        await PreferencesService.setTargetReachedToday(true);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("🎉 Target Achieved!"),
            content: Text("You’ve reached your daily application goal!"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Nice!"),
              ),
            ],
          ),
        );
      }
    }
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

    int remaining = await PreferencesService.getDailyRemaining();
    remaining = (remaining > 0) ? remaining - 1 : 0;
    await PreferencesService.saveDailyRemaining(remaining);

    if (remaining == 0) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("🎉 Target Achieved!"),
          content: Text("You’ve reached your daily application goal!"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("OK"))
          ],
        ),
      );
    }
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

  void _scheduleReminderIfNeeded() async {
    final now = DateTime.now();
    final remaining = await PreferencesService.getDailyRemaining();

    if (remaining > 0 && now.hour >= 20) {
      await showTargetReminderNotification(remaining);
    }
  }

  void _checkDailyReset() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastReset = await PreferencesService.getLastResetDate();

    if (lastReset != today) {
      final yesterday = DateTime.now().subtract(Duration(days: 1));
      final yDate = DateFormat('yyyy-MM-dd').format(yesterday);
      final prevCount = await PreferencesService.getDailyRemaining();
      final dailyTarget = await PreferencesService.getDailyTarget();

      await PreferencesService.addDailyStat(yDate, dailyTarget - prevCount);

      await PreferencesService.saveDailyRemaining(dailyTarget);
      await PreferencesService.saveLastResetDate(today);
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
              if (value == 'stats') Navigator.pushNamed(context, '/stats');
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 'view', child: Text('View Detailed Applications')),
              PopupMenuItem(value: 'reduce', child: Text('Reduce Count')),
              PopupMenuItem(value: 'reset', child: Text('Reset All')),
              PopupMenuItem(value: 'stats', child: Text('View Daily Stats')),
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
                _handleNewApplication();
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
              onPressed: () async {
                final result = await Navigator.pushNamed(context, '/form');
                if (result is Application) {
                  _handleNewApplication(app: result);
                }
              },
              child: Text("Detailed Entry", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
