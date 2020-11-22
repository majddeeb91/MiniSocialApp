import 'package:flutter/material.dart';

import '../../../../constants.dart';

class CreatePostTextField extends StatelessWidget {
  const CreatePostTextField({
    Key key,
    this.onChanged,
  }) : super(key: key);
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.25,
      margin: EdgeInsets.symmetric(horizontal: 30),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(offset: Offset(10, 10), blurRadius: 25, color: Colors.grey),
        ],
      ),
      child: TextFormField(
        validator: (val) => val.isEmpty ? "Post text should not be empty" : null,
        onChanged: onChanged,
        maxLines: null,
        expands: true,
        cursorColor: kPrimaryColor,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: "What's in your mind ?",
          hintStyle: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
