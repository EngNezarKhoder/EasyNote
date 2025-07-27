import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_easy_note/widgets/category_card.dart';
import 'package:my_easy_note/widgets/note_card.dart';
import 'package:my_easy_note/widgets/text_form_filed_search.dart';
import 'package:my_easy_note/widgets/time_card.dart';

class TabBarChild extends StatefulWidget {
  const TabBarChild(
      {super.key,
      required this.notes,
      required this.controller,
      required this.categoryName,
      required this.categoryId});
  final Stream<QuerySnapshot> notes;
  final TextEditingController controller;
  final String categoryName;
  final String categoryId;
  @override
  State<TabBarChild> createState() => _TabBarChildState();
}

class _TabBarChildState extends State<TabBarChild> {
  List<QueryDocumentSnapshot> allCategories = [];
  List<QueryDocumentSnapshot> filteredCategories = [];
  void showAwesmDialog(
      BuildContext context, DialogType type, String title, String msg,
      {void Function()? btnOkOnPress}) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.rightSlide,
      title: title,
      desc: msg,
      btnCancelOnPress: () {},
      btnOkOnPress: btnOkOnPress,
    ).show();
  }

  deleteNote(String id) {
    showAwesmDialog(context, DialogType.warning, "warning",
        "Are You Sure From Delete This Note?", btnOkOnPress: () async {
      await FirebaseFirestore.instance
          .collection("mycategories")
          .doc(widget.categoryId)
          .collection("note")
          .doc(id)
          .delete();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream: widget.notes,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Column(
              children: [
                const Icon(
                  Icons.error_rounded,
                  color: Colors.red,
                ),
                Text(
                  "Error",
                  style: TextStyle(color: Colors.grey[400]),
                )
              ],
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xff7B5CFA),
              ),
            );
          }
          allCategories = snapshot.data!.docs;
          filteredCategories = allCategories
              .where((doc) => doc['noteName']
                  .toString()
                  .toLowerCase()
                  .contains(widget.controller.text.toLowerCase()))
              .toList();
          if (allCategories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/nonote.png',
                  ),
                  Text(
                    "No Notes Yet",
                    style: TextStyle(color: Colors.grey[400]),
                  )
                ],
              ),
            );
          }
          if (filteredCategories.isEmpty) {
            return Column(
              children: [
                TextFormFiledSearch(
                    textEditingController: widget.controller,
                    onChanged: (value) {
                      setState(() {});
                    },
                    hintText: 'Search notes...',
                    color: Colors.white),
                SizedBox(height: height * 0.2),
                Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "No notes match your search.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                )
              ],
            );
          }
          return Column(
            children: [
              TextFormFiledSearch(
                  textEditingController: widget.controller,
                  onChanged: (value) {
                    setState(() {});
                  },
                  hintText: 'Search notes...',
                  color: Colors.white),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: filteredCategories.length,
                      itemBuilder: (context, index) {
                        final Timestamp timestamp =
                            filteredCategories[index]['time'];
                        final DateTime dateTime = timestamp.toDate();
                        final String formattedDate =
                            DateFormat('MMM dd, yyyy').format(dateTime);
                        final String formattedTime =
                            DateFormat('hh:mm a').format(dateTime);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 6),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CategoryCard(
                                    categoryName: widget.categoryName,
                                    noteId: filteredCategories[index].id,
                                    oldNameNote: filteredCategories[index]
                                        ['noteName'],
                                    categoryId: widget.categoryId),
                                const SizedBox(height: 10),
                                NoteCard(dataNote: filteredCategories[index]),
                                TimeCard(
                                    onPressed: () {
                                      deleteNote(filteredCategories[index].id);
                                    },
                                    formattedDate: formattedDate,
                                    formattedTime: formattedTime)
                              ],
                            ),
                          ),
                        );
                      }))
            ],
          );
        });
  }
}
