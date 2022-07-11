// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDirections {
  late LatLngBounds bounds;
  late List<PointLatLng> polylinePoints;
  late String totalDistance;
  late String totalDuration;

  PlaceDirections({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory PlaceDirections.fromJson(Map<String, dynamic> json) {
    var data = Map<String, dynamic>.from(json['routes'][0]);
    LatLng northeast = LatLng(
        data['bounds']['northeast']['lat'], data['bounds']['northeast']['lng']);
    LatLng southwest = LatLng(
        data['bounds']['southwest']['lat'], data['bounds']['southwest']['lng']);

    var distance = data['legs'][0]['distance']['text'];
    var duration = data['legs'][0]['duration']['text'];

    return PlaceDirections(
      bounds: LatLngBounds(northeast: northeast, southwest: southwest),
      polylinePoints:
          PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
    );
  }
}
