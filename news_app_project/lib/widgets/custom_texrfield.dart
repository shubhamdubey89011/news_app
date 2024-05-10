import 'package:flutter/material.dart';

class Customtextfield extends StatelessWidget {
  final String hintText;
  final bool secure;
  final IconData iconData;
  final TextEditingController controller;

  const Customtextfield(
      {super.key,
      required this.hintText,
      required this.secure,
      required this.controller,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          validator: (val) {
            if (val == null || val.isEmpty) {
              return "Provide ${hintText}";
            }
            return null;
          },
          controller: controller,
          obscureText: secure,
          decoration: InputDecoration(
              prefixIcon: Icon(iconData),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5))),
        ),
      ),
    );
  }
}