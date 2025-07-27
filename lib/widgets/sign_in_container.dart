import 'package:flutter/material.dart';

class SignInContainer extends StatelessWidget {
  const SignInContainer({super.key, required this.imagename});
  final String imagename;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xffF2F2F7),
        ),
        child: Row(
          children: [
            const Spacer(),
            const Text(
              "Login With Google",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff7B5CFA)),
            ),
            const SizedBox(
              width: 10,
            ),
            Image.asset(
              "images/$imagename",
            ),
            const Spacer()
          ],
        ));
  }
}
