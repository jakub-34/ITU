import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Template extends StatelessWidget {
  final String templateName;
  final VoidCallback newSession;
  final VoidCallback datePicker;
  final DateTime currentDate;

  const Template({
    super.key,
    required this.templateName,
    required this.newSession,
    required this.datePicker,
    required this.currentDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 410, maxHeight: 72),
        child: ElevatedButton(
          onPressed: newSession,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
            shadowColor: Colors.black.withOpacity(0.1),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Template name displayed on the button
              Center(
                child: Text(
                  templateName,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              // DatePickerButton as a child in the row
              Tooltip(
                message: "Set session date",
                child: ElevatedButton(
                  onPressed: datePicker,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        DateFormat("EEE, dd.MM.").format(currentDate),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
