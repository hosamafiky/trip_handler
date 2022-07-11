import 'package:trip_handler/data/models/location.dart';
import 'package:trip_handler/data/models/place_directions.dart';

abstract class MapsState {}

class MapsInitial extends MapsState {}

class MapsLocationSuggestionsLoaded extends MapsState {
  final List<dynamic> list;

  MapsLocationSuggestionsLoaded(this.list);
}

class MapsLocationSuggestionDetailsLoaded extends MapsState {
  final Location location;

  MapsLocationSuggestionDetailsLoaded(this.location);
}

class MapsLocationDirectionsLoaded extends MapsState {
  final PlaceDirections directions;

  MapsLocationDirectionsLoaded(this.directions);
}
