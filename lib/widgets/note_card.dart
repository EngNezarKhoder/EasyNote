import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.dataNote});
  final QueryDocumentSnapshot dataNote;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              dataNote['noteName'],
              style: TextStyle(fontSize: 15, color: Colors.grey[500]),
            ),
          ),
          Checkbox(
            value: dataNote['isCompleted'] ?? false,
            onChanged: (value) {
              dataNote.reference
                  .set({'isCompleted': value}, SetOptions(merge: true));
            },
            activeColor: const Color(0xff7B5CFA),
          )
        ],
      ),
    );
  }
}
