import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/common/widgets/custom_button.dart';
import 'package:whatsapp_ui/constants/colors.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName =
      '/loginScreen'; // we can use this route wherever we want for router.dart
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  /// choose country code using country picker
  void pickCountryCode() {
    showCountryPicker(
        context: context,
        showPhoneCode: true,
        onSelect: (Country chosenCountry) {
          setState(() {
            country = chosenCountry;
            // assign the chosen country to country variable
          });
        });
  }

  /// send phone number to the OTP screen through controller
  void sendPhoneNumber() {
    String phoneNumber = phoneController.text;

    // verify if both country and phone number are not null
    if (country != null && phoneNumber.isNotEmpty) {
      // Provider ref -> interact Provider with Provider
      // Widget ref -> makes widget interact with provider
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');

      // the firebase takes input as +911234567890 so we have to pass the input based  on that
    } else {
      showSnackBar(
          context: context,
          message: 'Enter valid country code and phone number');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // size of current screen
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Enter your phone number'),
          elevation: 0,
          backgroundColor: backgroundColor,
        ),
        // adding this helps with bottom yellow lines which we resolved before  resizeToAvoidBottomInset property
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(height: size.height * 0.12),
                // const Text(
                //   'Enter your phone number',
                //   style: TextStyle(fontSize: 22),
                // ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                const Text(
                  'Whatsapp will need to verify your number.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: size.height * 0.05),

                // we dont want any elevation but simple text button
                TextButton(
                  onPressed: pickCountryCode,
                  child: const Text(
                    'Pick Country',
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                // SizedBox(
                //   width: size.width * 0.8,
                //   child: const TextField(
                //     decoration: InputDecoration(
                //       border: UnderlineInputBorder(),
                //       labelText: 'phone Number',
                //     ),
                //   ),
                // ),
                Row(
                  children: [
                    if (country != null)
                      Text(
                        '+${country!.phoneCode}',
                        // style: const TextStyle(fontSize: 16),
                      ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: size.width * 0.7,
                      child: TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: 'phone Number',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.53),
                SizedBox(
                  width: size.width * 0.3,
                  child: CustomButton(text: 'Next', onPressed: sendPhoneNumber),
                ),
              ],
            ),
          ),
        ));
  }
}

// make this class go from StatefulWidget to ConsumerStatefulWidget to access the ref of Provider
// Consumer is used to access the Provider and it's advantage is it provides granular rebuild of widgets
// and solves BuildContext misuses better than Provider

// ref.read() -> read the value of the Provider and does same as Provider.of(context, listen: false)