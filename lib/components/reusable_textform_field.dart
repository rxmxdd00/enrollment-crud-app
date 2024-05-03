import 'package:crud_app/utils/constants.dart';
import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  const ReusableTextField(
      {super.key,
      required this.titleController,
      required this.valueChanged,
      required this.hintText,
      required this.validators,
      this.isObscure});

  final TextEditingController titleController;
  final ValueChanged<String> valueChanged;
  final String hintText;
  final dynamic validators;
  final bool? isObscure;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscure!,
      onChanged: valueChanged,
      controller: titleController,
      autofocus: true,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: kDefColor, width: 1.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      ),
      validator: validators,
      textInputAction: TextInputAction.next,
    );
  }
}
