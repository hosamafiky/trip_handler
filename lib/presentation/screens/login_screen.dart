import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/phone_auth/cubit/phone_auth_cubit.dart';
import '../../constants/strings.dart';
import '../widgets/phone_form_field.dart';
import '../widgets/submit_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Widget _buildIntroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'What\'s your phone number ?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: const Text(
            'Please enter phone number to verify your account.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is PhoneAuthSubmitted) {
          Navigator.pushNamed(
            context,
            otpRoute,
            arguments: controller.text,
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildIntroText(),
                        const SizedBox(height: 110.0),
                        PhoneFormField(
                          controller: controller,
                        ),
                        const SizedBox(height: 50.0),
                        SubmitButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              BlocProvider.of<PhoneAuthCubit>(context)
                                  .submitPhoneNumber(controller.text);
                            }
                          },
                        ),
                      ],
                    ),
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
      },
    );
  }
}
