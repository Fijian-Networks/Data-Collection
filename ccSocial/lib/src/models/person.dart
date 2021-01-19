import 'package:flutter/material.dart';

class Person {
  final String uuid;
  final String firstName;
  final String lastName;
  final int age;
  final String sex;
  final String householdId;
  final String village;
  final String photoName;
  String photoPath;

//constructor method, with all fields
  Person(
      {this.uuid,
      this.firstName,
      this.lastName,
      this.age,
      this.sex,
      this.householdId,
      this.village,
      this.photoName,
      this.photoPath});

// method to bring in sqlite entry and create a new Person instance.
// key value pair, where key is the column name from sqlite database, household_member
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
        uuid: json['_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        age: json['age'],
        sex: json['sex'],
        householdId: json['household_id'],
        village: json['village'],
        photoName: json['person_photo_uriFragment'] == null
            ? ''
            : json['person_photo_uriFragment']);
  }

// edits UUID to match path under folder instance, adds photoName
  String getPhotoPath(String _personInstanceDir) {
    // For local storage method, return formated instance and image name
    if (this.photoName == '') {
      // check if image present
      this.photoPath = "No Image";
      return "assets/noImage.jpg";
    } else {
      this.photoPath = _personInstanceDir +
          ((this.uuid + "/" + this.photoName).replaceAll(new RegExp(r"([:,-])"),
              "_")); //regex to change all '-' and ':' to '_'
      print(photoPath);
      return (photoPath);
    }
  }
}
