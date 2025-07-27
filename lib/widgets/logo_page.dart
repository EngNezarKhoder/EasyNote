import 'package:flutter/material.dart';

class LogoPage extends StatelessWidget {
  const LogoPage({super.key, required this.height});
  final double height;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: height * 0.14),
        child: Image.asset("images/note.png", ),
      ),
    );
  }
}
