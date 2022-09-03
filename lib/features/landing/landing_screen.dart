import 'package:flutter/material.dart';
import 'package:whatsapp_ui/common/widgets/custom_button.dart';
import 'package:whatsapp_ui/constants/colors.dart';
import 'package:whatsapp_ui/features/auth/screens/login_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

// function to go from Landing page to login screen
  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height / 12,
            ),
            const Text(
              'Welcome to Chatter',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: size.height / 10,
            ),
            Image.asset(
              'assets/images/bg.png',
              height: 340,
              width: 340,
              color: Colors.teal,
            ),
            SizedBox(
              height: size.height / 11,
            ),
            const Text(
              'Read our privacy policy. Tap "Agree and Continue" to accept the Terms of Service.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height / 25,
            ),
            // TODO: navigate to new screen
            SizedBox(
                width: size.width * 0.75,
                child: CustomButton(
                  text: 'AGREE AND CONTINUE',
                  onPressed: () => navigateToLoginScreen(context),
                ))

            // we cover it with sizedbox so we can  take full width and control the size each time of the button
          ],
        ),
      )),
    );
  }
}
