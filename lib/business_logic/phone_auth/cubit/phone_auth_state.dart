part of 'phone_auth_cubit.dart';

abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthLoading extends PhoneAuthState {}

class PhoneAuthError extends PhoneAuthState {
  final String error;

  PhoneAuthError(this.error);
}

class PhoneAuthSubmitted extends PhoneAuthState {}

class PhoneAuthVerified extends PhoneAuthState {}
