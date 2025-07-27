import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_easy_note/auth/login_page.dart';
import 'package:my_easy_note/auth/sign_up_page.dart';
import 'package:my_easy_note/category/add_category_page.dart';
import 'package:my_easy_note/category/update_category_page.dart';
import 'package:my_easy_note/home_page.dart';
import 'package:my_easy_note/main_page.dart';
import 'package:my_easy_note/note/note_add_page.dart';
import 'package:my_easy_note/note/note_update_page.dart';
import 'package:my_easy_note/note/note_view_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "mainpage": (_) => const MainPage(),
        "loginpage": (_) => const LoginPage(
              status: false,
            ),
        "signuppage": (_) => const SignUpPage(),
        "homepage": (_) => const HomePage(),
        "addcategorypage": (_) => const AddCategoryPage(),
        "updatecategorypage": (_) => const UpdateCategoryPage(
              theNameOfCategory: "",
              docid: "",
            ),
        "noteviewpage": (_) => const NoteViewPage(
              categoryid: "",
              categoryName: "",
            ),
        "noteaddpage": (_) => const NoteAddPage(
              categoryName: "",
              categoryid: "",
            ),
        "noteeditpage": (_) => const NoteUpdatePage(
              noteId: "",
              categoryid: "",
              categoryName: "",
              oldNameNote: "",
            ),
      },
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Color(0xff7B5CFA),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
              centerTitle: true)),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.emailVerified) {
              return const HomePage();
            } else {
              return const MainPage();
            }
          }),
      debugShowCheckedModeBanner: false,
    );
  }
}
