import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_easy_note/widgets/task_list_view.dart';

class TaskToday extends StatefulWidget {
  const TaskToday({super.key});

  @override
  State<TaskToday> createState() => _TaskTodayState();
}

class _TaskTodayState extends State<TaskToday> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> allnotes =
        FirebaseFirestore.instance.collectionGroup('note').snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
      ),
      body: Container(
        color: const Color(0xffF8E7F7),
        child: TaskListView(
          notes: allnotes,
        ),
      ),
    );
  }
}
