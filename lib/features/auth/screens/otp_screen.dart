import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/constants/colors.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

// Convert stateful to ConsumerStatefulWidget and stateless to ConsumerWidget for using ref here
// for using authControllerProvider

class OTPScreen extends ConsumerWidget {
  static const String routeName = '/otp-screen';
  final String verificationId;

  const OTPScreen({Key? key, required this.verificationId}) : super(key: key);

  void verifyOTP(WidgetRef ref, BuildContext context, String otp) {
    // we use this ref to for getting data from Stateless widget and use the read() to
    // use authControllerProvider and verifyOTP() to verify the otp

    // the read method reads the authController once and then performs the operation of verifyOTP()
    ref.read(authControllerProvider).verifyOTP(context, verificationId, otp);
  }

// we have to use WidgetRef since buildContext not available in stateless widget throughout
// WidgetRef communicates from widget to the providers
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size; // size of current screen
    return Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Verifying you number'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'We have sent an SMS with code.',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: size.width * 0.5,
                child: TextField(
                  onChanged: (value) {
                    // based  on value we check if numbers total=6, we call firebase's verifyPhoneNumber method
                    if (value.length == 6) {
                      // trim spaces from the value
                      verifyOTP(ref, context, value.trim());
                    }
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: "- - - - - -",
                    hintStyle: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
