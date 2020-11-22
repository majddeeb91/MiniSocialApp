import 'package:flutter/material.dart';
import '../../../../constants.dart';

class CreatePostHeader extends StatelessWidget {
  const CreatePostHeader({
    Key key,
    this.onTapCloseButton,
    this.onTapPostButton,
  }) : super(key: key);

  final Function onTapCloseButton;
  final Function onTapPostButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FlatButton(
            onPressed: onTapCloseButton,
            child: Icon(
              Icons.close,
              color: Colors.black54,
            ),
          ),
          Spacer(),
          FlatButton(
            onPressed: onTapPostButton,
            child: Text(
              "Post",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
