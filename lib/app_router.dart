import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_handler/business_logic/maps/maps_cubit.dart';
import 'package:trip_handler/data/respositories/google_maps_repository.dart';
import 'package:trip_handler/data/web_services/google_maps_api.dart';
import 'business_logic/phone_auth/cubit/phone_auth_cubit.dart';
import 'constants/strings.dart';

import 'presentation/screens/screens.dart';

class AppRouter {
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();
  MapsCubit mapsCubit = MapsCubit(GoogleMapsRepository(GoogleMapsApiService()));
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(
          builder: (context) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit,
            child: LoginScreen(),
          ),
        );
      case mapRoute:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => mapsCubit,
            child: const MapScreen(),
          ),
        );
      case otpRoute:
        final number = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: phoneAuthCubit,
            child: OtpScreen(number),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('No Screen is defined for this route.'),
            ),
          ),
        );
    }
  }
}
