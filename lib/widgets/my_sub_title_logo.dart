import 'package:flutter/material.dart';

class MySubTitleLogo extends StatelessWidget {
  const MySubTitleLogo({super.key});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: height * 0.06,
        ),
        Text("EASY"),
        Text(
          " NOTE",
          style:
              TextStyle(color: Color(0xff7B5CFA), fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
