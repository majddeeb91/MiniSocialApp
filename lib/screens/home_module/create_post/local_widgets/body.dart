import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_network_test/constants.dart';
import 'package:social_network_test/screens/home_module/create_post/create_post_viewmodel.dart';
import 'package:social_network_test/screens/home_module/create_post/local_widgets/create_post_header.dart';
import 'package:social_network_test/widgets/background.dart';
import 'dart:async';
import 'dart:io';

import 'add_image_floating_button.dart';
import 'attached_image.dart';
import 'create_post_text_field.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  File _imageFile;

  /// to store image from picker then upload it to firestore then get the download link
  String _postText = "";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _formKey = GlobalKey<FormState>();
    return Background(
        child: SafeArea(
      child: Form(
        key: _formKey,
        child: Container(
          child: Column(
            children: [
              CreatePostHeader(
                onTapPostButton:  () async {
                        if (_formKey.currentState.validate()) {
                        createPostViewModelInstance.createPost(
                            _postText, _imageFile,context);


                        }
                      },
                onTapCloseButton: () => Navigator.pop(context),
              ),
              SizedBox(height: size.height * 0.15),
              CreatePostTextField(
                onChanged: (value) async {
                  _postText = value;
                  //setState(() => _postText = value);
                },
              ),
              _imageFile != null
                  ? AttachedImage(
                      imageFile: _imageFile,
                      press: () {
                        setState(() {
                          _imageFile = null;
                        });
                      })
                  : Container(),
              Spacer(),
              AddImageFloatingButton(
                press: () async {
                  var pickedImage =
                      await ImagePicker().getImage(source: ImageSource.gallery);
                  setState(() {
                    _imageFile = File(pickedImage.path);
                    print('Image Path $_imageFile');
                  });
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    ));
  }
}
