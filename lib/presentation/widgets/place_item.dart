import 'package:flutter/material.dart';
import 'package:trip_handler/constants/palette.dart';
import 'package:trip_handler/data/models/place_suggestion.dart';

class PlaceItem extends StatelessWidget {
  final PlaceSuggestion suggestion;
  const PlaceItem(this.suggestion, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String subTitle = suggestion.description
        .replaceAll(suggestion.description.split(',')[0], '');
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        leading: Container(
          width: 40.0,
          height: 40.0,
          decoration: const BoxDecoration(
            color: Palette.lightBlue,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.place,
            color: Palette.blue,
          ),
        ),
        title: RichText(
          text: TextSpan(
            text: '${suggestion.description.split(',')[0]}\n',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: subTitle.substring(2),
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
