import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/phone_auth/cubit/phone_auth_cubit.dart';
import '../../constants/strings.dart';
import '../widgets/pin_code.dart';
import '../widgets/submit_button.dart';

// ignore: must_be_immutable
class OtpScreen extends StatelessWidget {
  final String phoneNumber;
  OtpScreen(this.phoneNumber, {Key? key}) : super(key: key);

  late String smsCode;
  Widget _buildIntroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Verify your phone number',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Please enter the 6 digits code sent to ',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: '+2$phoneNumber',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 18.0,
                    height: 1.4,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
        listener: (context, state) {
      if (state is PhoneAuthError) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error),
            duration: const Duration(seconds: 3),
          ),
        );
      } else if (state is PhoneAuthVerified) {
        Navigator.pushReplacementNamed(context, mapRoute);
      }
    }, builder: (context, state) {
      return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildIntroText(),
                    const SizedBox(height: 88.0),
                    PinCodeFields(
                      onCompleted: (userSubmittedVal) {
                        smsCode = userSubmittedVal!;
                      },
                    ),
                    const SizedBox(height: 68.0),
                    SubmitButton(
                      text: 'Verify',
                      onPressed: () {
                        BlocProvider.of<PhoneAuthCubit>(context)
                            .submitOTP(smsCode);
                      },
                    ),
                  ],
                ),
              ),
              if (state is PhoneAuthLoading)
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
