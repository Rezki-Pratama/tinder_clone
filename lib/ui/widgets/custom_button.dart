import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color, boxDecorationColor, textColor;
  CustomButton(
      {this.text, this.color, this.boxDecorationColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
        color: color,
        elevation: 20,
        borderRadius: BorderRadius.circular(size.height * 0.03),
        child: Container(
          height: size.height * 0.09,
          decoration: BoxDecoration(
            color: boxDecorationColor,
            borderRadius: BorderRadius.circular(size.height * 0.03),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: size.height * 0.040,
                color: textColor,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ));
  }
}
