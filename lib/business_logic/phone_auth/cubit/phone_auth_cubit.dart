import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  PhoneAuthCubit() : super(PhoneAuthInitial());

  late String verificationId;

  // Login Screen - Send SMS Message..
  Future<void> submitPhoneNumber(String phoneNumber) async {
    emit(PhoneAuthLoading());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> verificationCompleted(PhoneAuthCredential credential) async {
    log(credential.signInMethod);

    signIn(credential);
  }

  void verificationFailed(FirebaseAuthException exception) {
    log(exception.message!);
    emit(PhoneAuthError(exception.message!));
  }

  Future<void> codeSent(String verificationId, int? resendToken) async {
    log('Code Sent : $verificationId');
    this.verificationId = verificationId;
    emit(PhoneAuthSubmitted());
  }

  void codeAutoRetrievalTimeout() {
    log('codeAutoRetrievalTimeout');
  }

  // Submit OTP ..
  Future<void> submitOTP(String smsCode) async {
    emit(PhoneAuthLoading());
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    signIn(credential);
  }

  Future<void> signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneAuthVerified());
    } catch (error) {
      emit(PhoneAuthError(error.toString()));
    }
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  User getUserData() {
    return FirebaseAuth.instance.currentUser!;
  }
}
