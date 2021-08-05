import 'package:flutter/material.dart';
import 'dart:io';

class Person {
  final String uuid;
  final String firstName;
  final String lastName;
  final int age;
  final String sex;
  final String householdId;
  final String village;
  final String photoName;
  dynamic photo;
  String photoPath;
  Icon photoIcon;

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
      this.photoPath,
      this.photoIcon});

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
      village: json['village'] == null ? 'NA' : json['village'],
      photoName: json['person_photo_uriFragment'],
      photoIcon: json['person_photo_uriFragment'] == null
          ? Icon(Icons.image_not_supported)
          : Icon(Icons.photo),
    );
  }

// // edits UUID to match path under folder instance, adds photoName
//   String getPhotoPath(String _personInstanceDir) {
//     // For local storage method, return formated instance and image name
//     if (this.photoName.isEmpty) {
//       print('getPhotoPath(if 1) : ' + this.photoName);
//       // check if image present
//       this.photoPath = "No Image";
//       print("In getPhotoPath Method:  " + this.photoPath);
//       return "assets/noImage.jpg";
//     } else {
//       print('getPhotoPath(if 2) : ' + this.photoName);
//       this.photoPath = _personInstanceDir +
//           ((this.uuid + "/" + this.photoName).replaceAll(new RegExp(r"([:,-])"),
//               "_")); //regex to change all '-' and ':' to '_'
//       print("In getPhotoPath Method:  " + this.photoPath);
//       return (photoPath);
//     }
//   }

// edits UUID to match path under folder instance, adds photoName
  void setPhotoPath() {
    String dir =
        "/storage/emulated/0/opendatakit/default/data/tables/household_member/instances/";
    if (this.photoName == null) {
      this.photoPath = "assets/noImage.jpg";
      this.photo = AssetImage(this.photoPath);
    } else {
      this.photoPath = dir +
          ((this.uuid + "/" + this.photoName).replaceAll(new RegExp(r"([:,-])"),
              "_")); //regex to change all '-' and ':' to '_'
      this.photo = Image.file(File(this.photoPath)).image;
    }
    // print("Photopath:: " + this.photoPath);
  }

//get name
  String getName() {
    return (this.firstName + " " + this.lastName);
  }

// if age stated in year, return 'DOB: year', else return 'Age: ~~ '
  String getAge() {
    int age = this.age;
    String ageText;
    if (age == null) {
      ageText = "Deceased";
    } else if (age.toString().length > 3) {
      ageText = "DOB: " + age.toString();
    } else {
      ageText = "Age: " + age.toString();
    }
    return ageText;
  }

// Subtitle information parsing for list of Person
  Text detailsSubtitle() {
    //logic for age display
    int age = this.age;
    String ageText;
    if (age == null) {
      ageText = "Deceased";
    } else if (age.toString().length > 3) {
      ageText = "DOB: " + age.toString();
    } else {
      ageText = "Age: " + age.toString();
    }
    return Text(ageText + "    Village: " + this.village);
  }

  String getSurveyCsv() {
    return '';
  }
}
