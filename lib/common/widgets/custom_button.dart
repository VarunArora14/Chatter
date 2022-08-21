import 'package:flutter/material.dart';
import 'package:whatsapp_ui/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          primary: tealColor, minimumSize: const Size(double.infinity, 50)),
      child:
          Text(text, style: const TextStyle(color: blackColor, fontSize: 16)),
    );
  }
}

/*
this is a custom basic function so we need 2 main things - 
1. Text inside this button
2. OnPressed function which we can either make as VoidCallBack to return void or simply Function
*/
