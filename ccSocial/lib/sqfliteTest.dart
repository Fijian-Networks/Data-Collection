import 'package:ccSocial/src/models/person.dart';
import 'package:ccSocial/src/services/db_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Search for person page from SQLite DB sourced from ODK-X folder on tablet
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
    // calls _updateSearchList Method on live text entry
    searchController.addListener(_updateSearchList);
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

  Widget build(BuildContext context) {
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
              // TODO: Call selectedPerson and pass details to new screen for confirmation.
              onTap: () {
                selectedPerson = snapshot.data[index];
                // Can select all info from Person Model as key value pairs.
                // IE: print uuid of selected person
                // print(selectedPerson.uuid);
              },
            );
          },
        );
      },
    );
  }
}
