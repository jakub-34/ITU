import 'package:flutter/material.dart';
import 'package:itu_app/controllers/template_controller.dart';
import '../controllers/session_controller.dart';
import '../models/job.dart';
import '../services/hive_service.dart';

class AddSessionScreen extends StatefulWidget {
  final Job job;

  const AddSessionScreen({super.key, required this.job});

  @override
  _AddSessionScreenState createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _startTime;
  late DateTime _endTime;
  String _templateName = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final templateController = TemplateController(HiveService());
      templateController.addTemplate(
          widget.job.id, _startTime, _endTime, _templateName);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    constraints:
                        const BoxConstraints(maxWidth: 500, maxHeight: 150),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60)),
                  ),
                  validator: (value) => value!.isEmpty
                      ? 'Please set a name for the session type'
                      : null,
                  onSaved: (value) => _templateName = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '0',
                    constraints:
                        const BoxConstraints(maxWidth: 500, maxHeight: 150),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60)),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the start time' : null,
                  onSaved: (value) => _startTime = DateTime.tryParse(value!)!,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '0',
                    constraints:
                        const BoxConstraints(maxWidth: 500, maxHeight: 150),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60)),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the end time' : null,
                  onSaved: (value) => _endTime = DateTime.tryParse(value!)!,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0), // Align Total and button consistently
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 500, maxHeight: 150),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _submit();
                      },
                      label: const Text('Confirm',
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 138, vertical: 25),
                        backgroundColor:
                            Colors.white, // White button background
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
