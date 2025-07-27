import 'package:flutter/material.dart';

class TimeCard extends StatelessWidget {
  const TimeCard(
      {super.key,
      required this.formattedDate,
      required this.formattedTime,
    required   this.onPressed});
  final String formattedDate;
  final String formattedTime;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(formattedDate,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text(formattedTime, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.delete_forever_outlined,
                color: Colors.red, size: 30),
          )
        ],
      ),
    );
  }
}
