import 'package:flutter/material.dart';
import 'dart:io';

import 'package:async/async.dart';

class AttachedImage extends StatelessWidget {
  const AttachedImage({
    Key key,
    this.imageFile,
    this.press,
  }) : super(key: key);
  final File imageFile;
  final Function press;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        width: size.width * 0.9,
        height: size.height * 0.25,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: imageFile != null ? Image.file(
                imageFile,
                fit: BoxFit.cover,
                height: size.height * 0.25,
                width: size.width * 0.9,
              ) : null,
            ),
            Positioned(
                top: 15,
                right: 20,
                child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: press,
                    ))),
          ],
        ),
      ),
    );
  }
}