import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/application.dart';

class DetailedFormScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _company = TextEditingController();
  final _position = TextEditingController();
  final _location = TextEditingController();

  void _save(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final app = Application(
        companyName: _company.text,
        position: _position.text,
        location: _location.text,
        dateApplied: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
      Navigator.pop(context, app);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detailed Entry")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
                controller: _company,
                decoration: InputDecoration(labelText: 'Company Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null),
            TextFormField(
                controller: _position,
                decoration: InputDecoration(labelText: 'Position'),
                validator: (v) => v!.isEmpty ? 'Required' : null),
            TextFormField(
                controller: _location,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (v) => v!.isEmpty ? 'Required' : null),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () => _save(context), child: Text("Save")),
          ]),
        ),
      ),
    );
  }
}
