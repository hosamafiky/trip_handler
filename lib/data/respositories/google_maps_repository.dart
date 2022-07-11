import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip_handler/data/models/location.dart';
import 'package:trip_handler/data/models/place_directions.dart';
import 'package:trip_handler/data/models/place_suggestion.dart';
import 'package:trip_handler/data/web_services/google_maps_api.dart';

class GoogleMapsRepository {
  final GoogleMapsApiService googleMapsApiService;

  GoogleMapsRepository(this.googleMapsApiService);

  Future<List<PlaceSuggestion>> fetchPlaceSuggestions({
    required String input,
    required String sessiontoken,
  }) async {
    try {
      List<dynamic> suggestions = await googleMapsApiService
          .fetchPlaceSuggestionsjson(input: input, sessiontoken: sessiontoken);
      return suggestions
          .map((suggestion) => PlaceSuggestion.fromJson(suggestion))
          .toList();
    } catch (error) {
      log(error.toString());
      return [];
    }
  }

  Future<Location> fetchPlaceSuggestionDetails({
    required String placeId,
    required String sessiontoken,
  }) async {
    Map<String, dynamic> details =
        await googleMapsApiService.fetchPlaceSuggestionDetailsjson(
            placeId: placeId, sessiontoken: sessiontoken);
    return Location.fromJson(details);
  }

  Future<PlaceDirections> fetchPlaceSuggestionDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    var directions =
        await googleMapsApiService.fetchPlaceSuggestionDirectionsjson(
            origin: origin, destination: destination);

    return PlaceDirections.fromJson(directions);
  }
}
