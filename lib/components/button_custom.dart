import 'package:flutter/material.dart';

class CButton extends StatelessWidget {
  CButton(
      {super.key,
      required this.text,
      required this.iconData,
      this.textColor = Colors.white,
      this.buttonColor = Colors.black,
      this.onPressed});

  final String text;
  final IconData iconData;
  final Color textColor;
  final Color buttonColor;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: buttonColor, fixedSize: Size(double.infinity, 50)),
        child: Row(
          children: [
            Icon(iconData, color: textColor),
            Expanded(child: Center(child: Text(text, style: TextStyle(color: textColor)))),
          ],
        ),
      ),
    );
  }
}
