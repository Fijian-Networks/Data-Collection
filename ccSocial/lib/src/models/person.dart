import 'package:flutter/material.dart';

class Person {
  final String uuid;
  final String firstName;
  final String lastName;
  final int age;
  final String sex;
  final String
      householdId; //TODO Make a seperate entry for village, or parse from houeshold_id
  final Path photo = null; //TODO sort photo path later

//constructor method, with all fields
  Person(
      {this.uuid,
      this.firstName,
      this.lastName,
      this.age,
      this.sex,
      this.householdId});

// method to bring in sqlite entry and create a new Person instance.
// key value pair, where key is the column name from sqlite database, househole_member
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
        uuid: json['_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        age: json['age'],
        sex: json['sex'],
        householdId: json['household_id']);
  }
}
