import 'package:flutter/material.dart';
import 'package:trip_handler/constants/palette.dart';

class CardWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  const CardWidget({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            offset: Offset(2.0, 4.0),
            blurRadius: 5.0,
            color: Colors.black12,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Palette.blue,
            size: 25.0,
          ),
          const SizedBox(width: 5.0),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
