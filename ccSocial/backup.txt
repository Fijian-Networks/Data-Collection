// from line 111 pf searchPage.dart
// in future builder<List<Person>> _searchResults

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
                  // pass selected person and their instance directory to the details screen
                  return DetailScreen(selectedPerson, _odkxPersonInstanceDir);
                }));
              },
            );
          },
        );
      },
    );
  }