import 'package:flutter/material.dart';

import '../../../../constants.dart';

class EditProfileInputTextFormField extends StatelessWidget {
  const EditProfileInputTextFormField({
    Key key,
    this.title,
    this.hintText,
    this.enabled,
    this.onChanged,
    this.validator,
    this.icon,
    this.controller,
  }) : super(key: key);
  final String title, hintText;
  final bool enabled;
  final ValueChanged onChanged;
  final IconData icon;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 8, right: 15),
      child: TextFormField(
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
          ),
          //labelStyle: TextStyle(color: kPrimaryColor),
         // labelText: "Email",
          hintText: hintText,
        ),
      ),
    );
  }
}
