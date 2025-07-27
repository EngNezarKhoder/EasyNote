import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_easy_note/note/note_view_page.dart';
import 'package:my_easy_note/widgets/logo_page.dart';
import 'package:my_easy_note/widgets/my_custom_button.dart';
import 'package:my_easy_note/widgets/my_sub_title_logo.dart';
import 'package:my_easy_note/widgets/my_text_form_field_email.dart';

class NoteUpdatePage extends StatefulWidget {
  const NoteUpdatePage(
      {super.key,
      required this.categoryid,
      required this.categoryName,
      required this.oldNameNote,
      required this.noteId});
  final String categoryid;
  final String categoryName;
  final String oldNameNote;
  final String noteId;
  @override
  State<NoteUpdatePage> createState() => _NoteUpdatePageState();
}

class _NoteUpdatePageState extends State<NoteUpdatePage> {
  TextEditingController noteNameController = TextEditingController();
  late GlobalKey<FormState> formStateKey;
  bool isLoading = false;

  Future<void> _updateNote(context) async {
    setState(() => isLoading = true);
    FocusScope.of(context).unfocus();
    DateTime now = DateTime.now();
    try {
      final noteId = FirebaseFirestore.instance
          .collection("mycategories")
          .doc(widget.categoryid)
          .collection("note")
          .doc(widget.noteId);
      if (widget.oldNameNote != noteNameController.text) {
        await noteId.set({
          "noteName": noteNameController.text,
          "time": Timestamp.fromDate(now),
        }, SetOptions(merge: true));
      }
      noteNameController.clear();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => NoteViewPage(
              categoryid: widget.categoryid,
              categoryName: widget.categoryName)));
    } catch (error) {
      setState(() => isLoading = false);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: "Error",
        desc: "An Error Occurred",
        btnOkOnPress: () {},
      ).show();
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    noteNameController.text = widget.oldNameNote;
    formStateKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    noteNameController.dispose();
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
                        "Edit Note",
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
                    controller: noteNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "The Field Is Empty";
                      }
                      return null;
                    },
                    hintText: "‘Update The Note...",
                    icon: Icons.folder,
                  ),
                  SizedBox(height: height * 0.035),
                  MyCustomButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (formStateKey.currentState!.validate()) {
                              _updateNote(context);
                            }
                          },
                    height: height * 0.06,
                    color: const Color(0xff7B5CFA),
                    buttonTitle: "Save",
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 50),
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
