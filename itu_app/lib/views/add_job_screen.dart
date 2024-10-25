import 'package:flutter/material.dart';
import '../controllers/job_controller.dart';

class AddJobScreen extends StatefulWidget {
  final JobController jobController;

  const AddJobScreen({super.key, required this.jobController});

  @override
  _AddJobScreenState createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _hourlyRate = 0.0;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.jobController.addJob(_title, _hourlyRate);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Job')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Job Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Hourly Rate'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a rate' : null,
                onSaved: (value) =>
                    _hourlyRate = double.tryParse(value!) ?? 0.0,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Job'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
