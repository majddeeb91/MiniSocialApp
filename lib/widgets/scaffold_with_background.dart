import 'package:flutter/material.dart';
import 'background.dart';

class ScaffoldWithBackground extends StatelessWidget {
  const ScaffoldWithBackground({
    Key key,
    this.child,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Background(
            child: Container(
          color: Colors.transparent,
        )),
        child,
      ],
    ));
  }
}
