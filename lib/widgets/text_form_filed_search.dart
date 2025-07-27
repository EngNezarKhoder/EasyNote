import 'package:flutter/material.dart';

class TextFormFiledSearch extends StatelessWidget {
  const TextFormFiledSearch(
      {super.key,
      required this.textEditingController,
      required this.onChanged,
      required this.hintText, required this.color});
  final TextEditingController textEditingController;
  final void Function(String)? onChanged;
  final String hintText;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: textEditingController,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: hintText,
          filled: true,
          fillColor: color,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
