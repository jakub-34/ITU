import 'package:flutter/material.dart';

class FormSubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const FormSubmitButton({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 375, maxHeight: 80),
        child: ElevatedButton.icon(
          onPressed: onSubmit, // Pass the onSubmit function here
          label: const Text(
            'Confirm',
            style: TextStyle(color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 138, vertical: 25),
            backgroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
