import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_easy_note/auth/login_page.dart';
import 'package:my_easy_note/widgets/logo_page.dart';
import 'package:my_easy_note/widgets/my_custom_button.dart';
import 'package:my_easy_note/widgets/my_text_form_field_email.dart';
import 'package:my_easy_note/widgets/my_text_form_field_password.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController username;
  late TextEditingController email;
  late TextEditingController password;
  late GlobalKey<FormState> formStateKey;

  bool isLoading = false;
  void showAwesmDialog(
      BuildContext context, DialogType type, String title, String msg) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.rightSlide,
      title: title,
      desc: msg,
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    ).show();
  }

  _createAccount(context) async {
    if (formStateKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        FocusScope.of(context).unfocus();
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );
        if (credential.user != null) {
          credential.user!.sendEmailVerification();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const LoginPage(
                    status: true,
                  )));
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        if (e.code == 'weak-password') {
          showAwesmDialog(context, DialogType.error, "Error",
              'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          showAwesmDialog(context, DialogType.error, "Error",
              'The account already exists for that email.');
        }
      } catch (e) {
        showAwesmDialog(context, DialogType.error, "Error",
            'An unexpected error occurred. Please try again later.');
      }
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "The field is empty";
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  String? validateEmail(String? value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (value == null || value.isEmpty) {
      return "The field is empty";
    }
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  void initState() {
    username = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    formStateKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Form(
      key: formStateKey,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        backgroundColor: const Color(0xffF8E7F7),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  LogoPage(height: height),
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff7B5CFA)),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  MyTextFormFieldEmail(
                    controller: username,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "The Field Is Empty";
                      }
                      return null;
                    },
                    hintText: "username",
                    icon: Icons.person,
                  ),
                  SizedBox(
                    height: height * 0.025,
                  ),
                  MyTextFormFieldEmail(
                    controller: email,
                    validator: validateEmail,
                    hintText: "Email",
                    icon: Icons.email,
                  ),
                  SizedBox(
                    height: height * 0.025,
                  ),
                  MyTextFormFieldPassword(
                      controller: password,
                      validator: validatePassword,
                      hintText: "Password"),
                  SizedBox(
                    height: height * 0.035,
                  ),
                  MyCustomButton(
                      onPressed: () {
                        _createAccount(context);
                      },
                      height: height * 0.06,
                      color: const Color(0xff7B5CFA),
                      buttonTitle: "Sign Up",
                      textColor: Colors.white),
                  SizedBox(
                    height: height * 0.025,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "You Have An Account?",
                        style: TextStyle(
                            color: Color(0xff7B5CFA),
                            fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed("loginpage");
                          },
                          child: const Text("Sign In"))
                    ],
                  )
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff7B5CFA),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
