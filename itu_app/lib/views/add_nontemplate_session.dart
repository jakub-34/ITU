import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/session_controller.dart';
import '../models/job.dart';
import '../services/hive_service.dart';
import 'components/form_input.dart';
import 'components/from_submit_button.dart';

class AddNonTemplateSession extends StatefulWidget {
  final Job job;

  const AddNonTemplateSession({super.key, required this.job});

  @override
  _AddNonTemplateSessionState createState() => _AddNonTemplateSessionState();
}

class _AddNonTemplateSessionState extends State<AddNonTemplateSession> {
  final _formKey = GlobalKey<FormState>();
  final List<TimeOfDay?> _times = [null, null];
  DateTime _selectedDate = DateTime.now(); // Initialize with today's date
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill the date controller with today's date
    _dateController.text = DateFormat('dd.MM.yyyy').format(_selectedDate);
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final sessionController = SessionController(HiveService());
      await sessionController.addWorkSession(
        widget.job.id, // Ensure jobId is passed correctly
        date: _selectedDate,
        startTime: _times[0]!,
        endTime: _times[1]!,
        templateId: null,
      );
      WidgetsBinding.instance
          .addPostFrameCallback((_) => Navigator.pop(context));
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

  Future<void> _selectDateValue(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd.MM.yyyy').format(pickedDate);
      });
    }
  }

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    _dateController.dispose();
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
                  label: 'Select date',
                  suffixIcon: const Icon(Icons.calendar_today),
                  readOnly: true,
                  controller: _dateController,
                  onTap: () => _selectDateValue(context),
                  validator: (value) =>
                      value!.isEmpty ? 'Please select a date' : null,
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
