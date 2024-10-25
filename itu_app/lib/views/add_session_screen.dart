import 'package:flutter/material.dart';
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
  double _hoursWorked = 0.0;
  double _extraPay = 0.0;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final sessionController = SessionController(HiveService());
      sessionController.addWorkSession(
          widget.job.id, DateTime.now(), _hoursWorked, _extraPay);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Session for ${widget.job.title}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Hours Worked'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter hours worked' : null,
                onSaved: (value) =>
                    _hoursWorked = double.tryParse(value!) ?? 0.0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Extra Pay'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter extra pay' : null,
                onSaved: (value) => _extraPay = double.tryParse(value!) ?? 0.0,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Session'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
