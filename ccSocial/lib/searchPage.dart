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
  String _rootDir, _odkxPersonInstanceDir;
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

    setState(() {});
  }

  // permission check and set, Directory loading
  void initPermissionsState() async {
    if (await Permission.storage.request().isGranted) {
      _permissionStatus = await Permission.storage.status;
    }

    _rootDir = await ExtStorage.getExternalStorageDirectory();
    _odkxPersonInstanceDir = _rootDir +
        "/opendatakit/default/data/tables/household_member/instances/";
    dbService.initDatabase();

    setState(() {
      //init controllerText to empty
      _clearSearchControllerText();
    });
  }

  void _clearSearchControllerText() async {
    // init empty string for TextEditingController
    searchController.text = '';
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

// Methods for list interactions, should be in own file?
// method to copy UUID to clipboard, used on trailing icon in list view
  // copyToClipboard(Person selectedPerson, BuildContext context) {
  //   Clipboard.setData(ClipboardData(text: selectedPerson.uuid)).then((result) {
  //     final copyConfirmation = SnackBar(
  //       content: Text(
  //         "Copied to clipboard",
  //       ),
  //       action: SnackBarAction(
  //         label: "OK",
  //         onPressed: () {},
  //       ),
  //     );
  //     Scaffold.of(context).showSnackBar(copyConfirmation);
  //   });
  // }

  // UI
  Widget build(BuildContext context) {
    // Searchterms as typed in text
    return Scaffold(
      // Search text field
      appBar: AppBar(
        title: TextField(
            controller: searchController, //controller to trigger search strings
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 6, 0, 6),
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
            )),
        actions: [
          IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _clearSearchControllerText();
              })
        ],
      ),
      body: Container(
        // pass search results to populate list view
        // TODO: this is where the datatable would be called, if at all...
        child: _searchResults(searchController.text),
      ),
    );
  } //Build widget close

  // Method to get search results as a Future<List<Person>>
  FutureBuilder<List<Person>> _searchResults(String searchTerms) {
    return FutureBuilder<List<Person>>(
      //divider constructor after builder
      future: dbService.getPersons(query: searchTerms),
      builder: (BuildContext context, AsyncSnapshot<List<Person>> snapshot) {
        if (!snapshot.hasData)
          return ListView(
            children: [Text("Loading Database...")],
          );

        return ListView.separated(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            selectedPerson = snapshot.data[index];
            return ListTile(
              leading: Icon(selectedPerson.photoIcon.icon),
              //this is where we return the data entry variables.
              title: Text(selectedPerson.getName()),
              subtitle: selectedPerson.detailsSubtitle(),
              onTap: () {
                // create photoPath for selectedPerson
                snapshot.data[index].setPhotoPath();
                // detail screen, overlays image and data
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  // pass selected person to the details screen
                  return DetailScreen(snapshot.data[index]);
                }));
              },
              trailing: IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    copyToClipboard(snapshot.data[index], context);
                  }),
            );
          },
          // Divider Creation!
          separatorBuilder: (context, index) {
            return Divider();
          },
        );
      },
    );
  }
}

// create new screen containining photo and details to confirm exact human
class DetailScreen extends StatelessWidget {
  DetailScreen(this.selectedPerson);
  final Person selectedPerson;
  //Text Syle for details
  final TextStyle _ts = TextStyle(fontSize: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title:
              Text(selectedPerson.getName(), style: TextStyle(fontSize: 30))),
      body: Builder(
        builder: (context) => Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              (Text(selectedPerson.getAge(), style: _ts)),
              (Text("Sex: " + selectedPerson.sex, style: _ts)),
              (Text("Village: " + selectedPerson.village, style: _ts)),
              IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    copyToClipboard(selectedPerson,
                        context); //TODO:Snackbar confirmation for copying
                  })
            ],
          ),
          Expanded(
            child: Image(image: selectedPerson.photo, fit: BoxFit.fitHeight),
          )
        ]),
      ),
    );
  }
}

// Global Methods
// method to copy UUID to clipboard, used on trailing icon in list view
copyToClipboard(Person selectedPerson, BuildContext context) {
  Clipboard.setData(ClipboardData(text: selectedPerson.uuid)).then((result) {
    // final copyConfirmation = SnackBar(
    //   content: Text(
    //     "Copied to clipboard",
    //   ),
    //   action: SnackBarAction(
    //     label: "OK",
    //     onPressed: () {},
    //   ),
    // );
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        "Copied to clipboard",
      ),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
      ),
    ));
  });
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
