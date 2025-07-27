import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({
    super.key,
    required this.notes,
  });
  final Stream<QuerySnapshot> notes;
  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.notes,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xff7B5CFA),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
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
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final Timestamp timestamp =
                            snapshot.data!.docs[index]['time'];
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
                                Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        snapshot.data!.docs[index]
                                            ['categoryName'],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff7B5CFA)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          snapshot.data!.docs[index]
                                              ['noteName'],
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[500]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(formattedDate,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text(formattedTime,
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
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
