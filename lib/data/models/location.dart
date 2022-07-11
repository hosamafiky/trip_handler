class Location {
  late double latitude;
  late double longitude;

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['lat'];
    longitude = json['lng'];
  }
}
