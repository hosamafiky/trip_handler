import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip_handler/data/respositories/google_maps_repository.dart';
import 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  final GoogleMapsRepository googleMapsRepository;
  MapsCubit(this.googleMapsRepository) : super(MapsInitial());

  void emitLocationSuggestions({
    required String input,
    required String sessiontoken,
  }) {
    googleMapsRepository
        .fetchPlaceSuggestions(input: input, sessiontoken: sessiontoken)
        .then((value) {
      emit(MapsLocationSuggestionsLoaded(value));
    });
  }

  void emitLocationSuggestionDetails({
    required String placeId,
    required String sessiontoken,
  }) {
    googleMapsRepository
        .fetchPlaceSuggestionDetails(
            placeId: placeId, sessiontoken: sessiontoken)
        .then((value) {
      emit(MapsLocationSuggestionDetailsLoaded(value));
    });
  }

  void emitLocationSuggestionDirections({
    required LatLng origin,
    required LatLng destination,
  }) {
    googleMapsRepository
        .fetchPlaceSuggestionDirections(
            origin: origin, destination: destination)
        .then((value) {
      emit(MapsLocationDirectionsLoaded(value));
    });
  }
}
