import 'package:flutter/material.dart';

/// This class is used as a component of all forms
/// It creates an input filed with a label above it
class LabeledInputField extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final void Function()? onTap;
  final TextEditingController? controller;
  final String? hintText;
  final bool readOnly;
  final Icon? suffixIcon;
  final double width;

  const LabeledInputField({
    Key? key,
    this.width = 375,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onSaved,
    this.hintText,
    this.onTap,
    this.readOnly = false,
    this.controller,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        TextFormField(
          keyboardType: keyboardType,
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          validator: validator,
          onSaved: onSaved,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            constraints: BoxConstraints(maxWidth: width, maxHeight: 80),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(60),
            ),
          ),
        ),
      ],
    );
  }
}
