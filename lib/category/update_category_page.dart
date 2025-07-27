import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_easy_note/widgets/logo_page.dart';
import 'package:my_easy_note/widgets/my_custom_button.dart';
import 'package:my_easy_note/widgets/my_sub_title_logo.dart';
import 'package:my_easy_note/widgets/my_text_form_field_email.dart';

class UpdateCategoryPage extends StatefulWidget {
  const UpdateCategoryPage(
      {super.key, required this.theNameOfCategory, required this.docid});
  final String theNameOfCategory;
  final String docid;
  @override
  State<UpdateCategoryPage> createState() => _UpdateCategoryPageState();
}

class _UpdateCategoryPageState extends State<UpdateCategoryPage> {
  TextEditingController categoryName = TextEditingController();
  late GlobalKey<FormState> formStateKey;
  bool isLoading = false;
  CollectionReference categories =
      FirebaseFirestore.instance.collection("mycategories");
  Future<void> updateCategory(context) async {
    setState(() => isLoading = true);
    FocusScope.of(context).unfocus();

    try {
      await categories.doc(widget.docid).set({
        "categoryName": categoryName.text,
      }, SetOptions(merge: true));

      Navigator.of(context)
          .pushNamedAndRemoveUntil("homepage", (route) => false);
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Error",
        desc: "An error occurred",
        btnOkOnPress: () {},
      ).show();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    categoryName.text = widget.theNameOfCategory;
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
                        "Edit Category",
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
                      if (value == null || value.trim().isEmpty) {
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
                              updateCategory(context);
                            }
                          },
                    height: height * 0.06,
                    color: const Color(0xff7B5CFA),
                    buttonTitle: "Save",
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
