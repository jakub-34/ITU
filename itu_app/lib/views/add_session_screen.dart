import 'package:flutter/material.dart';
import 'package:itu_app/controllers/template_controller.dart';
import 'package:itu_app/views/components/from_submit_button.dart';
import 'package:itu_app/views/components/form_input.dart';
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
  final List<TimeOfDay?> _times = [null, null];
  String _templateName = '';
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final templateController = TemplateController(HiveService());
      templateController.addTemplate(
          widget.job.id, _times[0]!, _times[1]!, _templateName);
      Navigator.pop(context);
    }
  }

  Future<void> _selectTimeValue(
      BuildContext context, int index, TextEditingController controller) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _times[index] = pickedTime;
        controller.text = pickedTime.format(context);
      });
    }
  }

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
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
                LabeledInputField(
                  label: "Shift name",
                  validator: (value) => value!.isEmpty
                      ? 'Please set a name for the session type'
                      : null,
                  onSaved: (value) => _templateName = value!,
                ),
                _buildTimeFromField(context, 0, _startTimeController),
                _buildTimeFromField(context, 1, _endTimeController),
                FormSubmitButton(onSubmit: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LabeledInputField _buildTimeFromField(
      BuildContext context, int index, TextEditingController controller) {
    return LabeledInputField(
      label: "Select ${index == 0 ? 'start' : 'end'} time",
      controller: controller,
      suffixIcon: const Icon(Icons.access_time),
      readOnly: true,
      onTap: () => _selectTimeValue(context, index, controller),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the ${index == 0 ? 'start' : 'end'} time';
        }
        return null;
      },
    );
  }
}
