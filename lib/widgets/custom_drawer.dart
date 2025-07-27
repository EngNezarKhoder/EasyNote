import 'package:flutter/material.dart';
import 'package:my_easy_note/widgets/drawer_item.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer(
      {super.key,
      required this.onTapAdd,
      required this.onTapTask,
      required this.onTapSignOut});
  final void Function()? onTapAdd;
  final void Function()? onTapTask;
  final void Function()? onTapSignOut;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.deepPurple.shade400,
            Colors.deepPurple.shade100
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DrawerHeader(
                  child: Column(
                children: [
                  Icon(
                    Icons.note_alt_outlined,
                    size: 80,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "EASY NOTE",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2),
                  )
                ],
              )),
              DrawerItem(
                itemColor: Colors.white,
                iconData: Icons.folder,
                title: "Add Category",
                onTap: onTapAdd,
              ),
              DrawerItem(
                itemColor: Colors.white,
                iconData: Icons.task,
                title: "Tasks",
                onTap: onTapTask,
              ),
              const Spacer(),
              const Divider(
                color: Colors.white,
                thickness: .5,
              ),
              DrawerItem(
                itemColor: Colors.red[200] ?? Colors.white,
                iconData: Icons.exit_to_app,
                title: "Sign Out",
                onTap: onTapSignOut,
              ),
            ],
          ))),
    );
  }
}
