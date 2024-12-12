import 'package:flutter/material.dart';

class FormSubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const FormSubmitButton({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 375, maxHeight: 75),
      child: ElevatedButton.icon(
        onPressed: onSubmit, // Pass the onSubmit function here
        label: const Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Confirm',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(500, 150),
          backgroundColor: Colors.white, // White button background
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
