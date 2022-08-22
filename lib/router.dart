import 'package:flutter/material.dart';
import 'package:whatsapp_ui/common/widgets/error_page.dart';
import 'package:whatsapp_ui/features/auth/screens/login_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/user_info_screen.dart';
import 'package:whatsapp_ui/features/select_contacts/screens/select_contact_screen.dart';
import 'package:whatsapp_ui/screens/mobile_chat_screen.dart';

/// function to route based on route name along with passing arguments
Route<dynamic>? generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case OTPScreen.routeName:
      final String verificationId = routeSettings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );
    case UserInfoScreen.routeName:
      return MaterialPageRoute(builder: (_) => const UserInfoScreen());
    case SelectContactScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SelectContactScreen());
    case MobileChatScreen.routeName:
      return MaterialPageRoute(builder: (_) => const MobileChatScreen());
    default:
      return MaterialPageRoute(
          builder: (context) =>
              const ErrorPage(errortext: 'Wrong route name provided'));
  }
}
