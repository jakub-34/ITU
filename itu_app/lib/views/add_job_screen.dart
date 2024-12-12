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
  String? _hinText;

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
  void dispose() {
    super.dispose();
  }

  String? _validateWeekDayRate(String? rate) {
    if (rate == null) {
      return "Enter a pay rate";
    }
    var valueDouble = double.tryParse(rate);
    if (rate.isEmpty || valueDouble == null) {
      return "Please enter a valid pay";
    }

    if (valueDouble <= 0) {
      return "Pay rate must be positive!";
    }
    return null;
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
                label: "Job name*",
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) {
                  setState(() {
                    _title = value!;
                  });
                },
              ),
              LabeledInputField(
                  label: "Pay in Week*",
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => _validateWeekDayRate(value),
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        _hinText = null;
                      } else if (_validateWeekDayRate(value) == null) {
                        _hinText = value;
                      }
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      _weekdayRate = double.tryParse(value!) ?? 0.0;
                    });
                  }),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 375),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: _buildOptNumberInput(
                          labelText: "Saturday Pay",
                          hintText: _hinText,
                          onSaved: (value) =>
                              _saturdayRate = double.tryParse(value!) ?? 0.0),
                    ),
                    const SizedBox(width: 15),
                    Flexible(
                      child: _buildOptNumberInput(
                          labelText: "Sunday Pay",
                          hintText: _hinText,
                          onSaved: (value) {
                            setState(() {
                              _sundayRate = double.tryParse(value!) ?? 0.0;
                            });
                          }),
                    )
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 375),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: _buildOptNumberInput(
                          labelText: "Break Time (min)",
                          aditionalValidation: (value) =>
                              value >= 60 * 24 ? "Break is too long!" : null,
                          onSaved: (value) {
                            setState(() {
                              _breakHours =
                                  (double.tryParse(value!) ?? 0.0) / 60;
                            });
                          }),
                    ),
                    const SizedBox(width: 15),
                    Flexible(
                      child: Tooltip(
                        message: "How long unttill a mandatory break",
                        child: _buildOptNumberInput(
                            labelText: "Hours till break",
                            aditionalValidation: (value) =>
                                value >= 24 ? "Shift is too long!" : null,
                            onSaved: (value) {
                              setState(() {
                                _hoursTillBreak =
                                    double.tryParse(value!) ?? 0.0;
                              });
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              Tooltip(
                message: "Recomended for jobs with consistent work schedule",
                child: CheckboxListTile.adaptive(
                    title: const Text(
                      "Use templates",
                      style: TextStyle(color: Colors.white),
                    ),
                    value: _usetTemplates,
                    onChanged: (newVal) {
                      setState(() {
                        _usetTemplates = newVal!;
                      });
                    }),
              ),
              FormSubmitButton(
                onSubmit: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  LabeledInputField _buildOptNumberInput({
    required String labelText,
    required FormFieldSetter<String> onSaved,
    String? Function(double)? aditionalValidation,
    String? hintText,
  }) {
    return LabeledInputField(
      label: labelText,
      width: 180,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onSaved: onSaved,
      hintText: hintText ?? "0",
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
        return aditionalValidation?.call(valueDouble);
      },
    );
  }
}
