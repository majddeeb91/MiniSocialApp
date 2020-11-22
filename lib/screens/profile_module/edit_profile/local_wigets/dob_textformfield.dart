import 'package:flutter/material.dart';
import '../../../../constants.dart';

class DOBTextFormField extends StatelessWidget {
  const DOBTextFormField({
    Key key,
    @required this.onTap, this.initialValue, this.controller,
  }) : super(key: key);

  final TextEditingController controller;
  final String initialValue;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 8, right: 15),
      child: TextField(
        //initialValue: initialValue,
        cursorColor: kPrimaryColor,
        controller: controller,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: "DOB",
          icon: Icon(
            Icons.calendar_today,
            color: kPrimaryColor,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
          ),
        ),
      ),
    );
  }
}
