import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/widgets/error_page.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/constants/colors.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/landing/landing_screen.dart';
import 'package:whatsapp_ui/firebase_options.dart';
import 'package:whatsapp_ui/router.dart';
import 'package:whatsapp_ui/screens/mobile_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // ProviderScope keeps track of all the providers and their states
  runApp(const ProviderScope(child: MyApp()));
}

// used for initializing firebase app as WidgetFlutterBinding is used to interact with flutter engine.
// Firebase.initializeApp() needs to call native code to initialize
// Firebase, and since the plugin needs to use platform channels to call the native code, which is done asynchronously
// therefore you have to call ensureInitialized() to
// make sure that you have an instance of the WidgetsBinding.

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp UI Clone',
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: backgroundColor, appBarTheme: const AppBarTheme(color: appBarColor)),
      onGenerateRoute: (settings) => generateRoute(settings),
      // here we use watch as it isbuild method and read is one time while watch keepschecking for changes
      // this when is used with FutureProvider. Here data is for usermodel, error is for how to handle error
      // and loading is for loading screen
      home: ref.watch(userDataProvider).when(
            data: (user) {
              // decide what to do when user null or not null
              if (user == null) return const LandingPage();
              return const MobileLayout();
            },
            error: (error, stackTrace) {
              debugPrintStack(stackTrace: stackTrace); // debugPrint the stack
              return ErrorPage(errortext: error.toString());
            },
            loading: () => const Loader(),
          ),
      // both are widgets(scaffolds) being used to decide the layout
    );
  }
}
