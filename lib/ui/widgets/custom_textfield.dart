import 'package:flutter/material.dart';
import 'package:tinder/ui/utilities.dart';

class CustomTextField extends StatelessWidget {
  final Size size;
  final TextEditingController controller;
  final Function validator;
  final String hintText;
  final bool autoCorrect, obscureText;

  CustomTextField(
      {this.size,
      this.controller,
      this.validator,
      this.hintText,
      this.autoCorrect,
      this.obscureText});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 20,
      borderRadius: BorderRadius.circular(size.height * 0.03),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: size.height * 0.01, horizontal: size.height * 0.02),
        child: TextFormField(
          controller: controller,
          autovalidate: true,
          autocorrect: autoCorrect,
          obscureText: obscureText,
          validator: validator,
          style: TextStyle(color: colorRed),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: -10),
            border:
                UnderlineInputBorder(borderSide: BorderSide(color: colorRed)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
            hintText: hintText,
            errorStyle: TextStyle(color: colorRed),
            hintStyle: TextStyle(color: colorRed, fontSize: size.height * 0.02),
          ),
        ),
      ),
    );
  }
}
