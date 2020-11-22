import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email = '';
  String firstName = '';
  String lastName = '';
  DateTime dob ;
  String userID;
  String profilePictureURL = '';
  String description = '';

  UserModel(
      {this.email,
      this.firstName,
      this.lastName,
      this.dob,
      this.userID,
      this.profilePictureURL,
      this.description});

  String fullName() {
    return '$firstName $lastName';
  }

  factory UserModel.fromJson(Map<String, dynamic> parsedJson) {
    return UserModel(
        email: parsedJson['email'] ?? "",
        firstName: parsedJson['first_name'] ?? '',
        lastName: parsedJson['last_name'] ?? '',
        dob: parsedJson['dob'].toDate(),
        userID: parsedJson['id'] ?? '',
        profilePictureURL: parsedJson['profile_picture_url'] ?? "",
        description: parsedJson['description'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "email": this.email,
      "first_name": this.firstName,
      "last_name": this.lastName,
      "id": this.userID,
      'dob': this.dob,
      "profile_picture_url": this.profilePictureURL,
      "description": this.description,
    };
  }
}


//dob: parsedJson['dob']==null?null:DateTime.parse(parsedJson['dob'].toString()),
// class UserModel{
//   String uid;
//   String username;
//   String firstName;
//   String lastNName;
//   DateTime dateOfBirth;
//   String imageUrl;
//
//   UserModel({this.uid});
// }
