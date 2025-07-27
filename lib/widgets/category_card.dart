import 'package:flutter/material.dart';
import 'package:my_easy_note/note/note_update_page.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard(
      {super.key,
      required this.categoryName,
      required this.noteId,
      required this.oldNameNote,
      required this.categoryId});
  final String categoryName;
  final String noteId;
  final String oldNameNote;
  final String categoryId;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            categoryName,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff7B5CFA)),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NoteUpdatePage(
                        noteId: noteId,
                        oldNameNote: oldNameNote,
                        categoryid: categoryId,
                        categoryName: categoryName)));
              },
              icon: const Icon(Icons.edit, color: Color(0xff7B5CFA))),
        ],
      ),
    );
  }
}
