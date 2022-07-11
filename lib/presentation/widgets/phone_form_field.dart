import 'package:flutter/material.dart';
import '../../constants/palette.dart';

class PhoneFormField extends StatelessWidget {
  final TextEditingController? controller;
  const PhoneFormField({
    Key? key,
    this.controller,
  }) : super(key: key);

  String _generateCountryFlag() {
    String country = 'eg';
    return country.toUpperCase().replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) =>
              String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 16.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(
                width: 1.0,
                color: Palette.lightGrey,
              ),
            ),
            child: Text(
              '${_generateCountryFlag()} +20',
              style: const TextStyle(
                letterSpacing: 1.2,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 2.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(
                width: 1.0,
                color: Palette.blue,
              ),
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 18.0,
                letterSpacing: 1.2,
              ),
              decoration: const InputDecoration(border: InputBorder.none),
              cursorColor: Colors.black,
              autofocus: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your phone number.';
                } else if (value.length != 11) {
                  return 'Not valid phone number';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
