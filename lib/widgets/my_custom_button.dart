import 'package:flutter/material.dart';

class MyCustomButton extends StatelessWidget {
  const MyCustomButton(
      {super.key,
      required this.onPressed,
      required this.height,
      required this.color,
      required this.buttonTitle,
      required this.textColor});
  final void Function()? onPressed;
  final double height;
  final Color color;
  final String buttonTitle;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      height: height,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      color: color,
      textColor: textColor,
      child: Text(
        buttonTitle,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }
}
