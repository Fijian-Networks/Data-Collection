import 'dart:io';
import 'package:flutter/services.dart';
import 'package:ccSocial/src/models/person.dart';
import 'package:ccSocial/src/services/db_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ext_storage/ext_storage.dart';

// Search for person page from SQLite DB sourced from ODK-X folder on tablet
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
//Permissions!
  // Permission permission;
  PermissionStatus _permissionStatus;
  // Paths
  String _rootDir, _odkxDBPath, _odkxPersonInstanceDir;
  // init empty db service
  final dbService = DatabaseService();
  // Search text input link for on the fly update of search results
  final searchController = TextEditingController();
  // storage variable for search results
  Future<List<Person>> searchResults;
  // stores Person for new screen displaying details and photo
  Person selectedPerson;
  // init searchTerms to empty string
  String searchTerms = '';

  @override
  void initState() {
    super.initState();

    initPermissionsState();
    // calls _updateSearchList Method on live text entry
    searchController.addListener(_updateSearchList);
    // init empty string for TextEditingController
    searchController.text = '';
  }

  // permission check and set, Directory loading
  void initPermissionsState() async {
    if (await Permission.storage.request().isGranted) {
      _permissionStatus = await Permission.storage.status;
    }

    _rootDir = await ExtStorage.getExternalStorageDirectory();
    _odkxDBPath = _rootDir + "/opendatakit/default/data/webDB/sqlite.db";
    _odkxPersonInstanceDir = _rootDir +
        "/opendatakit/default/data/tables/household_member/instances/";

    //Debug Text
    print("Permissions :: " + _permissionStatus.toString());
    print("_rootDir :: " + _rootDir);
    print("DBPath :: " + _odkxDBPath);
    print("PersonInstanceDir :: " + _odkxPersonInstanceDir);

    setState(() {});
  }

  // method called on text input
  void _updateSearchList() async {
    // refreshes searchresults anytime text is input to search bar
    setState(() {
      searchResults = dbService.getPersons(query: searchController.text);
    });
  }

  // flush existing services at end of use
  @override
  void dispose() {
    dbService.dispose();
    searchController.dispose();
    super.dispose();
  }

  // UI
  // TODO: make results appear as datatable?

  Widget build(BuildContext context) {
    //testFileStorage();
    // Searchterms as typed in text
    return Scaffold(
      appBar: AppBar(
        title: TextField(
            controller: searchController, //controller to trigger search strings
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 6, 0, 6),
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
            )),
      ),
      body: Container(
        child: _searchResults(searchController.text),
      ),
    );
  } //Build widget close

  // Method to get search results as a Future<List<Person>>
  FutureBuilder<List<Person>> _searchResults(String searchTerms) {
    return FutureBuilder<List<Person>>(
      future: dbService.getPersons(query: searchTerms),
      builder: (BuildContext context, AsyncSnapshot<List<Person>> snapshot) {
        if (!snapshot.hasData)
          return ListView(
            children: [Text("loading")],
          );

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              //this is where we return the data entry variables.
              title: Text(snapshot.data[index].firstName +
                  ' ' +
                  snapshot.data[index].lastName),
              // On Tap, selects the persons file and stores as selectedPerson.
              onTap: () {
                selectedPerson = snapshot.data[index];
                // create photoPath for selectedPerson
                selectedPerson.getPhotoPath(_odkxPersonInstanceDir);
                // detail screen, overlays image and data

                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return DetailScreen(selectedPerson,
                      _odkxPersonInstanceDir); //need to pass a person object through here.
                }));
              },
            );
          },
        );
      },
    );
  }
}

// create new screen containining photo and details to confirm exact human
class DetailScreen extends StatelessWidget {
  DetailScreen(this.selectedPerson, this._personInstanceDir);
  final Person selectedPerson;
  final String _personInstanceDir;

  @override
  Widget build(BuildContext context) {
    //logic to handle no image found
    // create untyped var to populate with either AssetImage or Image.file
    var personPhoto;
    if (selectedPerson.photoName == "") {
      personPhoto = AssetImage("assets/noImage.jpg");
    } else {
      personPhoto =
          Image.file(File(selectedPerson.getPhotoPath(_personInstanceDir)))
              .image;
    }

    return Scaffold(
      body: GestureDetector(
        child: Center(
            child: Hero(tag: 'imageHero', child: Image(image: personPhoto))),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
