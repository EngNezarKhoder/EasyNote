import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem(
      {super.key,
      required this.onTap,
      required this.iconData,
      required this.title,
      required this.itemColor});
  final void Function()? onTap;
  final IconData iconData;
  final String title;
  final Color itemColor;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        iconData,
        color: itemColor,
        size: 28,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: itemColor, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
