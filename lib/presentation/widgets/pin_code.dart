import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../constants/palette.dart';

class PinCodeFields extends StatelessWidget {
  final Function(String?) onCompleted;
  const PinCodeFields({Key? key, required this.onCompleted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      backgroundColor: Colors.transparent,
      animationType: AnimationType.scale,
      keyboardType: TextInputType.number,
      hintCharacter: '0',
      cursorColor: Colors.black,
      enableActiveFill: true,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(10.0),
        borderWidth: 1.0,
        activeColor: Palette.blue,
        activeFillColor: Palette.lightBlue,
        inactiveFillColor: Colors.white,
        inactiveColor: Colors.blue,
        selectedFillColor: Colors.white,
      ),
      onCompleted: onCompleted,
      onChanged: (value) {},
    );
  }
}
