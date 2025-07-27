import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_easy_note/category/add_category_page.dart';
import 'package:my_easy_note/category/update_category_page.dart';
import 'package:my_easy_note/note/note_view_page.dart';
import 'package:my_easy_note/note/all_task.dart';
import 'package:my_easy_note/widgets/custom_drawer.dart';
import 'package:my_easy_note/widgets/text_form_filed_search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // All Categories
  List<QueryDocumentSnapshot> allCategories = [];
  // Search Result
  List<QueryDocumentSnapshot> filteredCategories = [];
  // Controller Of Text Filed Search
  late TextEditingController searchController;
  // Key For Scaffold
  late GlobalKey<ScaffoldState> scaffoldKey;
  // My Categories
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("mycategories");
  // MY Dialog
  void showAwesmDialog(BuildContext context, DialogType type, String title,
      String msg, String btnCancelText, String btnOkText,
      {void Function()? btnCancelOnPress, void Function()? btnOkOnPress}) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.rightSlide,
      title: title,
      desc: msg,
      btnCancelText: btnCancelText,
      btnOkText: btnOkText,
      btnCancelOnPress: btnCancelOnPress,
      btnOkOnPress: btnOkOnPress,
    ).show();
  }

  // Function To Delete Or Edit Category
  updateOrDeleteCategory(dataCategory) {
    showAwesmDialog(context, DialogType.question, "Question", "What You Need?",
        "Delete", "Update", btnCancelOnPress: () {
      collectionReference.doc(dataCategory.id).delete();
    }, btnOkOnPress: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UpdateCategoryPage(
                theNameOfCategory: dataCategory['categoryName'],
                docid: dataCategory.id,
              )));
    });
  }

  final Stream<QuerySnapshot> categories = FirebaseFirestore.instance
      .collection("mycategories")
      .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  // Function To Sign Out
  _signOut(context) async {
    await FirebaseAuth.instance.signOut();
    GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.signOut();
    Navigator.of(context)
        .pushNamedAndRemoveUntil("loginpage", (route) => false);
  }

  @override
  void initState() {
    searchController = TextEditingController();
    scaffoldKey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed("addcategorypage");
          },
          backgroundColor: const Color(0xff7B5CFA),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        drawer: CustomDrawer(
          onTapAdd: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddCategoryPage()));
          },
          onTapTask: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TaskToday()));
          },
          onTapSignOut: () {
            _signOut(context);
          },
        ),
        appBar: AppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(5), right: Radius.circular(5)),
            ),
            toolbarHeight: height * 0.11,
            title: const Text(
              "EASY NOTE",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
        body: StreamBuilder(
            stream: categories,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Column(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                    Text(
                      "An Error Accoured",
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
                  .where((doc) => doc['categoryName']
                      .toString()
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()))
                  .toList();
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/nonote.png',
                      ),
                      Text(
                        "No Categories Yet",
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
                        textEditingController: searchController,
                        color: const Color(0xffF8E7F7),
                        onChanged: (value) {
                          setState(() {});
                        },
                        hintText: 'Search categories...'),
                    SizedBox(
                      height: height * 0.2,
                    ),
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
                      textEditingController: searchController,
                      color: const Color(0xffF8E7F7),
                      onChanged: (value) {
                        setState(() {});
                      },
                      hintText: 'Search categories...'),
                  Expanded(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, childAspectRatio: 1.25),
                        itemCount: filteredCategories.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onLongPress: () {
                              updateOrDeleteCategory(filteredCategories[index]);
                            },
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NoteViewPage(
                                      categoryName: filteredCategories[index]
                                          ['categoryName'],
                                      categoryid:
                                          filteredCategories[index].id)));
                            },
                            child: Card(
                              color: const Color(0xffF8E7F7),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.folder,
                                    size: height * 0.135,
                                    color: const Color(0xff7B5CFA),
                                  ),
                                  Text(
                                    filteredCategories[index]['categoryName'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff7B5CFA)),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              );
            }));
  }
}
