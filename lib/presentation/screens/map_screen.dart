import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip_handler/business_logic/maps/maps_cubit.dart';
import 'package:trip_handler/business_logic/maps/maps_state.dart';
import 'package:trip_handler/data/models/location.dart';
import 'package:trip_handler/data/models/place_directions.dart';
import 'package:trip_handler/data/models/place_suggestion.dart';
import 'package:trip_handler/presentation/widgets/card_widget.dart';
import 'package:trip_handler/presentation/widgets/place_item.dart';
import 'package:uuid/uuid.dart';
import '../../constants/palette.dart';
import '../../helpers/location_helper.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import '../widgets/my_drawer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static Position? position;
  final Completer<GoogleMapController> _completer = Completer();
  static final CameraPosition _myLocationCameraPosition = CameraPosition(
    target: LatLng(position!.latitude, position!.longitude),
    bearing: 0.0,
    tilt: 0.0,
    zoom: 19.0,
  );
  FloatingSearchBarController barController = FloatingSearchBarController();
  List<dynamic> suggestions = [];

  // Location Variables..
  Set<Marker> markers = {};
  Location? _selectedLocation;
  PlaceSuggestion? _selectedSuggestion;
  CameraPosition? _selectedLocationCameraPosition;
  Marker? currentLocationMarker;
  Marker? selectedLocationMarker;

  // Directions Variables..
  PlaceDirections? placeDirections;
  List<LatLng> polylinePoints = [];
  bool isSearchedPlaceMarkerClicked = false;

  @override
  void initState() {
    super.initState();
    setMyCurrentLocation();
  }

  addSelectedLoactionMarker() {
    selectedLocationMarker = Marker(
      markerId: const MarkerId('1'),
      position: _selectedLocationCameraPosition!.target,
      onTap: () {
        addCurrentLocationMarker();
        setState(() {
          isSearchedPlaceMarkerClicked = true;
        });
      },
      infoWindow: InfoWindow(title: _selectedSuggestion!.description),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markers.add(selectedLocationMarker!);
    });
  }

  addCurrentLocationMarker() {
    currentLocationMarker = Marker(
      markerId: const MarkerId('2'),
      position: LatLng(position!.latitude, position!.longitude),
      onTap: () {},
      infoWindow: const InfoWindow(title: 'Your Current Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markers.add(currentLocationMarker!);
    });
  }

  Future<void> setMyCurrentLocation() async {
    await LocationHelper.determineCurrentLocation();

    position = await Geolocator.getLastKnownPosition()
        .whenComplete(() => setState(() => {}));
  }

  Future<void> goToMyCurrentLocation() async {
    final GoogleMapController mapController = await _completer.future;
    mapController.animateCamera(
        CameraUpdate.newCameraPosition(_myLocationCameraPosition));
  }

  Widget _buildMap() {
    return GoogleMap(
      markers: markers,
      compassEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: _myLocationCameraPosition,
      polylines: isSearchedPlaceMarkerClicked
          ? {
              Polyline(
                polylineId: const PolylineId('1'),
                points: polylinePoints,
                width: 3,
                color: Palette.blue,
              ),
            }
          : {},
      onMapCreated: (GoogleMapController controller) {
        _completer.complete(controller);
      },
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Find a place..',
      controller: barController,
      scrollPadding: const EdgeInsets.only(bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        _getSearchQuerySuggestion(query);
      },
      onFocusChanged: (_) {
        setState(() {
          isSearchedPlaceMarkerClicked = false;
        });
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [_buildLocationSuggestionBloc()],
            ),
          ),
        );
      },
    );
  }

  void _getSearchQuerySuggestion(String query) {
    final sessiontoken = const Uuid().v4();
    BlocProvider.of<MapsCubit>(context)
        .emitLocationSuggestions(input: query, sessiontoken: sessiontoken);
  }

  Widget _buildLocationSuggestionBloc() {
    return BlocBuilder<MapsCubit, MapsState>(
      builder: (context, state) {
        if (state is MapsLocationSuggestionsLoaded) {
          suggestions = state.list;
          if (suggestions.isNotEmpty) {
            return _buildPlacesList();
          } else {
            return const SizedBox.shrink();
          }
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildPlacesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        var suggestion = suggestions[index];
        return InkWell(
          onTap: () {
            _selectedSuggestion = suggestion;
            getSelectedPlaceDetails(suggestion.placeId);
            barController.close();
          },
          child: PlaceItem(suggestion),
        );
      },
      itemCount: suggestions.length,
    );
  }

  void getSelectedPlaceDetails(String placeId) {
    final sessiontoken = const Uuid().v4();
    BlocProvider.of<MapsCubit>(context).emitLocationSuggestionDetails(
        placeId: placeId, sessiontoken: sessiontoken);
  }

  void getSelectedPlaceDirections() {
    BlocProvider.of<MapsCubit>(context).emitLocationSuggestionDirections(
      origin: LatLng(position!.latitude, position!.longitude),
      destination:
          LatLng(_selectedLocation!.latitude, _selectedLocation!.longitude),
    );
  }

  void _getDirectionsPolyline() {
    polylinePoints = placeDirections!.polylinePoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  void setUpCameraPosition() {
    _selectedLocationCameraPosition = CameraPosition(
      bearing: 0.0,
      tilt: 0.0,
      zoom: 19.0,
      target: LatLng(_selectedLocation!.latitude, _selectedLocation!.longitude),
    );
  }

  void _goToSelectedLocation() async {
    setUpCameraPosition();
    final GoogleMapController mapController = await _completer.future;
    mapController.animateCamera(
        CameraUpdate.newCameraPosition(_selectedLocationCameraPosition!));
    addSelectedLoactionMarker();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is MapsLocationSuggestionDetailsLoaded) {
          _selectedLocation = state.location;
          _goToSelectedLocation();
          getSelectedPlaceDirections();
        } else if (state is MapsLocationDirectionsLoaded) {
          placeDirections = state.directions;
          _getDirectionsPolyline();
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          drawer: const MyDrawer(),
          body: Stack(
            fit: StackFit.expand,
            children: [
              position != null
                  ? _buildMap()
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
              buildFloatingSearchBar(),
              if (isSearchedPlaceMarkerClicked) ...[
                Positioned(
                  left: 10.0,
                  top: 85.0,
                  child: CardWidget(
                    icon: Icons.access_time_filled,
                    text: placeDirections!.totalDuration,
                  ),
                ),
                Positioned(
                  right: 10.0,
                  top: 85.0,
                  child: CardWidget(
                    icon: Icons.directions_car_filled,
                    text: placeDirections!.totalDistance,
                  ),
                ),
              ],
            ],
          ),
          floatingActionButton: Container(
            margin: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 30.0),
            child: FloatingActionButton(
              backgroundColor: Palette.blue,
              onPressed: goToMyCurrentLocation,
              child: const Icon(
                Icons.location_pin,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
