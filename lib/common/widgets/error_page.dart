import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String errortext;
  const ErrorPage({Key? key, required this.errortext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(errortext),
      ),
    );
  }
}
