import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip_handler/constants/strings.dart';

class GoogleMapsApiService {
  late Dio dio;

  GoogleMapsApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: googleMapsApiUrl,
        receiveDataWhenStatusError: true,
        receiveTimeout: 20 * 1000,
        sendTimeout: 20 * 1000,
      ),
    );
  }

  Future<List<dynamic>> fetchPlaceSuggestionsjson({
    required String input,
    required String sessiontoken,
  }) async {
    try {
      Response response = await dio.get(
        'place/autocomplete/json',
        queryParameters: {
          'input': input,
          'types': 'geocode',
          'components': 'country:eg',
          'sessiontoken': sessiontoken,
          'key': googleMapsApiKey,
        },
      );
      return response.data['predictions'];
    } catch (error) {
      log(error.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchPlaceSuggestionDetailsjson({
    required String placeId,
    required String sessiontoken,
  }) async {
    try {
      Response response = await dio.get(
        'place/details/json',
        queryParameters: {
          'place_id': placeId,
          'fields': 'geometry',
          'sessiontoken': sessiontoken,
          'key': googleMapsApiKey,
        },
      );
      return response.data['result']['geometry']['location'];
    } catch (error) {
      log(error.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchPlaceSuggestionDirectionsjson({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      Response response = await dio.get(
        'directions/json',
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': googleMapsApiKey,
        },
      );
      return response.data;
    } catch (error) {
      log(error.toString());
      return {};
    }
  }
}
