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
  double _weekdayRate = 0.0;
  double _saturdayRate = 0.0;
  double _sundayRate = 0.0;
  double _breakHours = 0.0;
  double _hoursTillBreak = 0.0;
  bool _usetTemplates = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.jobController.addJob(_title, _weekdayRate, _saturdayRate,
          _sundayRate, _breakHours, _hoursTillBreak, _usetTemplates);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Add Job')),
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Job name',
                  constraints:
                      const BoxConstraints(maxWidth: 375, maxHeight: 80),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60)),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Pay in week',
                  constraints:
                      const BoxConstraints(maxWidth: 375, maxHeight: 80),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a rate' : null,
                onSaved: (value) =>
                    _weekdayRate = double.tryParse(value!) ?? 0.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOptNumberInput('Saturday Pay',
                      (value) => _saturdayRate = double.tryParse(value) ?? 0.0),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                  _buildOptNumberInput('Sunday Pay',
                      (value) => _sundayRate = double.tryParse(value) ?? 0.0),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOptNumberInput(
                      'Break Time (min)',
                      (value) => _breakHours =
                          1 / (60 / (double.tryParse(value) ?? 0.0))),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                  _buildOptNumberInput(
                      'Hours till break',
                      (value) =>
                          _hoursTillBreak = double.tryParse(value) ?? 0.0),
                ],
              ),
              CheckboxListTile.adaptive(
                title: const Text(
                  "use templates",
                  style: TextStyle(color: Colors.white),
                ),
                value: _usetTemplates,
                onChanged: (bool? newVal) {
                  setState(() {
                    _usetTemplates = newVal!;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0), // Align Total and button consistently
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: 375, maxHeight: 80),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _submit();
                    },
                    label: const Text('Confirm',
                        style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 138, vertical: 25),
                      backgroundColor: Colors.white, // White button background
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
    );
  }

  TextFormField _buildOptNumberInput(String labelText, func) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        hintText: '0',
        constraints: const BoxConstraints(maxWidth: 180, maxHeight: 80),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(60)),
      ),
      keyboardType: TextInputType.number,
      onSaved: func,
    );
  }
}
