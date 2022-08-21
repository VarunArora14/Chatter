// This is for deciding th screen size and the way we will show if bigger screen or smaller

import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  // we input 2 widgets from the fn we call as required values so we return layout based on size
  final Widget mobileLayout;
  final Widget webLayout;
  const ResponsiveLayout(
      {Key? key, required this.mobileLayout, required this.webLayout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // contraints is the main thing here, 600 for mobile and 900 for tablet
        if (constraints.maxWidth > 600) {
          // WEB SCREEN
          return webLayout;
        } else {
          // MOBILE SCREEN
          return mobileLayout;
        }
      },
    );
  }
}
