import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final AlignmentGeometry alignment;
  final String text;
  final VoidCallback onPressed;
  const SubmitButton({
    Key? key,
    this.alignment = Alignment.centerRight,
    this.text = 'Next',
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
          elevation: 0.0,
          minimumSize: const Size(110.0, 50.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
