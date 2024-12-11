import 'package:flutter/material.dart';
import '../controllers/job_controller.dart';
import 'components/from_submit_button.dart';
import 'components/form_input.dart';

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

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await widget.jobController.addJob(_title, _weekdayRate, _saturdayRate,
          _sundayRate, _breakHours, _hoursTillBreak, _usetTemplates);

      WidgetsBinding.instance
          .addPostFrameCallback((_) => Navigator.pop(context));
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LabeledInputField(
                label: "Job name",
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) {
                  setState(() {
                    _title = value!;
                  });
                },
              ),
              LabeledInputField(
                  label: "Pay in Week",
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null) {
                      return "Enter a pay rate";
                    }
                    var valueDouble = double.tryParse(value);
                    if (value.isEmpty || valueDouble == null) {
                      return "Please enter a valid pay";
                    }

                    if (valueDouble <= 0) {
                      return "Pay rate must be positive!";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _weekdayRate = double.tryParse(value!) ?? 0.0;
                    });
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOptNumberInput(
                      labelText: "Saturday Pay",
                      onSaved: (value) =>
                          _saturdayRate = double.tryParse(value!) ?? 0.0),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                  _buildOptNumberInput(
                      labelText: "Sunday Pay",
                      onSaved: (value) {
                        setState(() {
                          _sundayRate = double.tryParse(value!) ?? 0.0;
                        });
                      })
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOptNumberInput(
                      labelText: "Break Time (min)",
                      onSaved: (value) {
                        setState(() {
                          _breakHours = (double.tryParse(value!) ?? 0.0) / 60;
                        });
                      }),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                  _buildOptNumberInput(
                      labelText: "Hours till break",
                      onSaved: (value) {
                        setState(() {
                          _hoursTillBreak = double.tryParse(value!) ?? 0.0;
                        });
                      }),
                ],
              ),
              CheckboxListTile.adaptive(
                  title: const Text(
                    "use templates",
                    style: TextStyle(color: Colors.white),
                  ),
                  value: _usetTemplates,
                  onChanged: (newVal) {
                    setState(() {
                      _usetTemplates = newVal!;
                    });
                  }),
              FormSubmitButton(
                onSubmit: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  LabeledInputField _buildOptNumberInput(
      {required String labelText, required void Function(String?) onSaved}) {
    return LabeledInputField(
      label: labelText,
      width: 180,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onSaved: onSaved,
      hintText: "0",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return null;
        }
        var valueDouble = double.tryParse(value);
        if (value.isNotEmpty && valueDouble == null) {
          return "invalid number";
        }
        if (valueDouble == null) {
          return "invalid number";
        }
        if (valueDouble < 0) {
          return "can't be negative";
        }
        return null;
      },
    );
  }
}
