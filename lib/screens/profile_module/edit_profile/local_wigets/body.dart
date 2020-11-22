import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:social_network_test/models/networking_response.dart';
import 'package:social_network_test/models/user_model.dart';
import 'package:social_network_test/screens/profile_module/edit_profile/edit_profile_viewmodel.dart';
import 'package:social_network_test/utils/helper.dart';
import 'package:social_network_test/widgets/background.dart';
import 'package:social_network_test/widgets/rounded_button.dart';
import '../../../../constants.dart';
import 'dob_textformfield.dart';
import 'edit_profile_input_text_form_field.dart';

class Body extends StatefulWidget {
  const Body({Key key, this.commingUser}) : super(key: key);
  final UserModel commingUser;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  /// to store image from picker then upload it to firestore then get the download link
  File _imageFile;

  /// to store image url that comming from profile screen
  String _imageUrl;

  UserModel editedUser = UserModel();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController;
  TextEditingController descController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    var date = formatterDateTime(widget.commingUser.dob);

    firstNameController.text = widget.commingUser.firstName;
    lastNameController.text = widget.commingUser.lastName;
    descController.text = widget.commingUser.description;
    dobController = TextEditingController(text: date);
    editedUser = widget.commingUser;
    _imageUrl = widget.commingUser.profilePictureURL;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Stack(children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: _imageFile == null
                        ? NetworkImage(_imageUrl)
                        : FileImage(_imageFile),
                  ),
                  Positioned(
                      left: 0,
                      bottom: 0,
                      child: IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () async {
                          var pickedImage = await ImagePicker()
                              .getImage(source: ImageSource.gallery);
                          setState(() {
                            _imageFile = File(pickedImage.path);
                            print('Image Path $_imageFile');
                          });
                        },
                      ))
                ]),
              ),
              SizedBox(
                height: 20,
              ),
              EditProfileInputTextFormField(
                controller: firstNameController,
                hintText: "First name",
                icon: Icons.person,
                validator: (val) => val.isEmpty ? "Enter first name" : null,
                onChanged: (value) {
                  setState(() => editedUser.firstName = value);
                },
              ),
              EditProfileInputTextFormField(
                controller: lastNameController,
                hintText: "Last name",
                icon: Icons.person,
                validator: (val) => val.isEmpty ? "Enter last name" : null,
              ),
              DOBTextFormField(
                controller: dobController,
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _selectDate(context);
                },
              ),
              EditProfileInputTextFormField(
                controller: descController,
                hintText: "Description",
                icon: Icons.description,
                validator: (val) => val.isEmpty ? "Enter description" : null,
                onChanged: (value) {
                  setState(() => editedUser.description = value);
                },
              ),
              SizedBox(
                height: 20,
              ),
              RoundedButton(
                text: "Save",
                color: kPrimaryColor,
                textColor: Colors.white,
                press: () async {
                  if (_formKey.currentState.validate()) {
                    editedUser.firstName = firstNameController.text;
                    editedUser.lastName = lastNameController.text;
                    editedUser.dob = selectedDate;
                    editedUser.description = descController.text;
                    editedUser.userID = widget.commingUser.userID;
                    editedUser.profilePictureURL = _imageUrl;
                    editedUser.email = widget.commingUser.email;

                    /// if user choose a new profile picture
                    if (_imageFile != null) {
                      await editProfileViewModel
                          .uploadProfilePicture(
                              _imageFile, editedUser.userID, context)
                          .then((fireStroeResponse) => {
                                if (fireStroeResponse is FireStoreResponseData)
                                  {
                                    editedUser.profilePictureURL =
                                        fireStroeResponse.responseDataModel,
                                    editProfileViewModel
                                        .updateProfileData(editedUser, context)
                                        .then((user) =>
                                            {Navigator.pop(context, user)})
                                  }
                                else if (fireStroeResponse
                                    is FireStoreResponseData)
                                  {
                                    print(
                                        'error while updating profile in view model')
                                  }
                              });
                    }

                    ///  if user did not choose pic from image picker
                    else {
                      await editProfileViewModel
                          .updateProfileData(editedUser, context)
                          .then((user) => {Navigator.pop(context, user)});
                    }

                    // Navigator.pop(context, editedUser);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    descController.dispose();
    dobController.dispose();
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dobController.text = formatterDateTime(selectedDate.toLocal());

        // selectedDate.toLocal()
      });
  }
}
