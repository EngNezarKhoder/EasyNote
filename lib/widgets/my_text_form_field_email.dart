import 'package:flutter/material.dart';

class MyTextFormFieldEmail extends StatelessWidget {
  const MyTextFormFieldEmail(
      {super.key,
      required this.controller,
      required this.validator,
      required this.hintText,
      required this.icon});
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hintText;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: const Color(0xff7B5CFA),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xff7B5CFA)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff7B5CFA), width: 1.5),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff7B5CFA), width: 2),
            borderRadius: BorderRadius.circular(10)),
        disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff7B5CFA), width: 1.5),
            borderRadius: BorderRadius.circular(10)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(10)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
