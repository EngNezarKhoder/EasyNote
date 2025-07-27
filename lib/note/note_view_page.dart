import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_easy_note/note/note_add_page.dart';
import 'package:my_easy_note/widgets/tab_bar_child.dart';

class NoteViewPage extends StatefulWidget {
  const NoteViewPage(
      {super.key, required this.categoryid, required this.categoryName});
  final String categoryid;
  final String categoryName;
  @override
  State<NoteViewPage> createState() => _NoteViewPageState();
}

class _NoteViewPageState extends State<NoteViewPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late TextEditingController searchAllController;
  late TextEditingController searchCompletedController;
  late TextEditingController searchIncompletedController;
  List<QueryDocumentSnapshot> allCategories = [];
  List<QueryDocumentSnapshot> filteredCategories = [];
  bool isSelected = false;

  @override
  void initState() {
    searchAllController = TextEditingController();
    searchCompletedController = TextEditingController();
    searchIncompletedController = TextEditingController();
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    searchAllController.dispose();
    searchCompletedController.dispose();
    searchIncompletedController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference notesRef = FirebaseFirestore.instance
        .collection("mycategories")
        .doc(widget.categoryid)
        .collection("note");
    Stream<QuerySnapshot> allnotes = notesRef.snapshots();
    Stream<QuerySnapshot> completednotes =
        notesRef.where("isCompleted", isEqualTo: true).snapshots();
    Stream<QuerySnapshot> incompletednotes =
        notesRef.where("isCompleted", isEqualTo: false).snapshots();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteAddPage(
                      categoryid: widget.categoryid,
                      categoryName: widget.categoryName,
                    )));
          },
          backgroundColor: const Color(0xff7B5CFA),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
            title: Text(widget.categoryName),
            bottom: TabBar(
                labelStyle: const TextStyle(color: Colors.white, fontSize: 16),
                indicatorColor: const Color(0xffF8E7F7),
                unselectedLabelStyle:
                    TextStyle(color: Colors.grey[300], fontSize: 14),
                tabs: const [
                  Tab(
                    text: "All",
                  ),
                  Tab(
                    text: "Completed",
                  ),
                  Tab(
                    text: "Incomplete",
                  ),
                ])),
        body: WillPopScope(
          child: Container(
            color: const Color(0xffF8E7F7),
            child: TabBarView(children: [
              TabBarChild(
                  categoryId: widget.categoryid,
                  notes: allnotes,
                  controller: searchAllController,
                  categoryName: widget.categoryName),
              TabBarChild(
                  categoryId: widget.categoryid,
                  notes: completednotes,
                  controller: searchCompletedController,
                  categoryName: widget.categoryName),
              TabBarChild(
                  categoryId: widget.categoryid,
                  notes: incompletednotes,
                  controller: searchIncompletedController,
                  categoryName: widget.categoryName),
            ]),
          ),
          onWillPop: () async {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("homepage", (route) => false);
            return false;
          },
        ),
      ),
    );
  }
}
