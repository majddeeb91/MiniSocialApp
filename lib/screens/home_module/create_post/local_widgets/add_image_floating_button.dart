import 'package:flutter/material.dart';
import '../../../../constants.dart';

class AddImageFloatingButton extends StatelessWidget {
  const AddImageFloatingButton({
    Key key, this.press,
  }) : super(key: key);
  final Function press;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FloatingActionButton(
            backgroundColor: kPrimaryColor,
            onPressed: press,
            tooltip: 'Pick Image',
            child: Icon(
              Icons.image,
            ),
          ),
        ],
      ),
    );
  }
}