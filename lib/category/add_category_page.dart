import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_easy_note/home_page.dart';
import 'package:my_easy_note/widgets/logo_page.dart';
import 'package:my_easy_note/widgets/my_custom_button.dart';
import 'package:my_easy_note/widgets/my_sub_title_logo.dart';
import 'package:my_easy_note/widgets/my_text_form_field_email.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  late TextEditingController categoryName;
  late GlobalKey<FormState> formStateKey;
  bool isLoading = false;
  CollectionReference categories =
      FirebaseFirestore.instance.collection("mycategories");
  Future<void> _addCategory(context) async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      await categories.add({
        "categoryName": categoryName.text,
        "id": FirebaseAuth.instance.currentUser!.uid,
      });

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Error",
        desc: "An Error Occurred",
        btnOkOnPress: () {},
      ).show();
    } finally {
      setState(() {
        isLoading = false;
        categoryName.clear();
      });
    }
  }

  @override
  void initState() {
    categoryName = TextEditingController();
    formStateKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    categoryName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: formStateKey,
      child: Scaffold(
        backgroundColor: const Color(0xffF8E7F7),
        appBar: AppBar(toolbarHeight: 0),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  SizedBox(height: height * 0.02),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10)),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).maybePop();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Color(0xff7B5CFA),
                          ),
                        ),
                      ),
                      SizedBox(width: width / 5),
                      const Text(
                        "Add Category",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff7B5CFA)),
                      )
                    ],
                  ),
                  LogoPage(height: height * 0.6),
                  const MySubTitleLogo(),
                  SizedBox(height: height * 0.05),
                  MyTextFormFieldEmail(
                    controller: categoryName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "The Field Is Empty";
                      }
                      return null;
                    },
                    hintText: "Enter The Category Name...",
                    icon: Icons.folder,
                  ),
                  SizedBox(height: height * 0.04),
                  MyCustomButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (formStateKey.currentState!.validate()) {
                              _addCategory(context);
                            }
                          },
                    height: height * 0.06,
                    color: const Color(0xff7B5CFA),
                    buttonTitle: "Add",
                    textColor: Colors.white,
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
              ),
          ],
        ),
      ),
    );
  }
}
