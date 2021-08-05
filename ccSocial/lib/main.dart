import 'package:flutter/material.dart';
import 'package:ccSocial/searchPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cooperation and Conflict Social network surveys',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //links to  searchpage file for testing
      home: SearchPage(), //need to work on survey app now...
    );
  }
}
