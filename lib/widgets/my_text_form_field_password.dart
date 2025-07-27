import 'package:flutter/material.dart';

class MyTextFormFieldPassword extends StatefulWidget {
  const MyTextFormFieldPassword(
      {super.key,
      required this.controller,
      required this.validator,
      required this.hintText});
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hintText;

  @override
  State<MyTextFormFieldPassword> createState() =>
      _MyTextFormFieldPasswordState();
}

class _MyTextFormFieldPasswordState extends State<MyTextFormFieldPassword> {
  bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: isHidden,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.lock,
          color: Color(0xff7B5CFA),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isHidden = !isHidden;
            });
          },
          icon: const Icon(
            Icons.remove_red_eye_outlined,
            color: Color(0xff7B5CFA),
          ),
        ),
        hintText: widget.hintText,
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
