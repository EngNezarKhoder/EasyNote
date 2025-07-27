import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_easy_note/widgets/logo_page.dart';
import 'package:my_easy_note/widgets/my_custom_button.dart';
import 'package:my_easy_note/widgets/my_text_form_field_email.dart';
import 'package:my_easy_note/widgets/my_text_form_field_password.dart';
import 'package:my_easy_note/widgets/sign_in_container.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.status});
  final bool status;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  _signIn(context) async {
    try {
      setState(() {
        isLoading = true;
      });
      FocusScope.of(context).unfocus();
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
      if (credential.user != null) {
        if (credential.user!.emailVerified) {
          FocusScope.of(context).unfocus();
          Navigator.of(context)
              .pushNamedAndRemoveUntil("homepage", (route) => false);
        } else {
          setState(() {
            isLoading = false;
          });
          credential.user!.sendEmailVerification();
          showAwesmDialog(context, DialogType.warning, 'Warning',
              'Please Verify Your Email And Try Again.');
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        showAwesmDialog(context, DialogType.error, 'Error',
            'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showAwesmDialog(context, DialogType.error, 'Error',
            'Wrong password provided for that user.');
      } else if (e.code == 'invalid-credential') {
        showAwesmDialog(context, DialogType.error, 'Error',
            'The credentials are invalid or expired.');
      } else {
        showAwesmDialog(
            context, DialogType.error, 'Error', 'An unknown error occurred.');
      }
    } catch (e) {
      showAwesmDialog(context, DialogType.error, 'Error',
          'An unexpected error occurred. Please try again later.');
    }
  }

  Future<void> signInWithGoogle(context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route) => false);
  }

  _resetYourPassword(context) async {
    if (email.text.isEmpty) {
      showAwesmDialog(context, DialogType.error, 'Error',
          'Please Write Your Email And Try Again.');
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
      showAwesmDialog(context, DialogType.warning, 'Warning',
          'Please Go To Your Email And Reset Your Password.');
    } catch (e) {
      showAwesmDialog(context, DialogType.error, 'Error',
          'Please Make Sure You Entered Your Email Correctly.');
    }
  }

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    formStateKey = GlobalKey<FormState>();
    if (widget.status) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showAwesmDialog(context, DialogType.warning, 'Warning',
            'Please Go To Your Email And Verify It And Then Complete Regiester.');
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
                  const SizedBox(height: 10,),
                  const Center(
                    child: Text(
                      "Sign In",
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
                    controller: email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "The Field Is Empty";
                      }
                      return null;
                    },
                    hintText: "Email",
                    icon: Icons.email,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  MyTextFormFieldPassword(
                      controller: password,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "The Field Is Empty";
                        }
                        return null;
                      },
                      hintText: "Password"),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: () {
                          _resetYourPassword(context);
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Color(0xff7B5CFA)),
                        )),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  MyCustomButton(
                      onPressed: () {
                        if (formStateKey.currentState!.validate()) {
                          _signIn(context);
                        }
                      },
                      height: height * 0.06,
                      color: const Color(0xff7B5CFA),
                      buttonTitle: "Sign In",
                      textColor: Colors.white),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: (width / 3) - 10,
                        child: const Divider(
                          thickness: 1,
                          color: Color(0xff7B5CFA),
                        ),
                      ),
                      const Text(
                        "Or Login With",
                        style: TextStyle(color: Color(0xff7B5CFA)),
                      ),
                      SizedBox(
                        width: (width / 3) - 10,
                        child: const Divider(
                          thickness: 1,
                          color: Color(0xff7B5CFA),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  InkWell(
                      onTap: () {
                        signInWithGoogle(context);
                      },
                      child: const SignInContainer(imagename: "google.png")),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't Have An Account?",
                        style: TextStyle(
                            color: Color(0xff7B5CFA),
                            fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed("signuppage");
                          },
                          child: const Text("Sign Up"))
                    ],
                  ),
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
