import 'package:flutter/material.dart';
import 'package:my_easy_note/widgets/logo_page.dart';
import 'package:my_easy_note/widgets/my_custom_button.dart';
import 'package:my_easy_note/widgets/my_sub_title_logo.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      backgroundColor: const Color(0xffF8E7F7),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: ListView(
          children: [
            LogoPage(height: height),
            const MySubTitleLogo(),
            SizedBox(
              height: height * 0.08,
            ),
            MyCustomButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("loginpage");
                },
                height: (height * 0.06).clamp(45, 65),
                textColor: Colors.white,
                color: const Color(0xff7B5CFA),
                buttonTitle: "Sign In"),
            const SizedBox(
              height: 12,
            ),
            MyCustomButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("signuppage");
                },
                height: (height * 0.06).clamp(45, 65),
                color: const Color(0xffF2F2F7),
                textColor: const Color(0xff7B5CFA),
                buttonTitle: "Register"),
          ],
        ),
      ),
    );
  }
}
