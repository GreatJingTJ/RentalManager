import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rental_manager/Locations/show_all.dart';
import 'package:rental_manager/language.dart';
import 'package:rental_manager/tabs/account.dart';
import 'package:rental_manager/tabs/locations.dart';
import '../globals.dart' as globals;
import 'package:firebase_storage/firebase_storage.dart';
import '../Locations/category_page.dart';
import 'custom_location_card.dart';

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListPageState();
  }
}

List<DocumentSnapshot> doclist =[];
Widget customCardios(int index,DocumentSnapshot snapshot, BuildContext context) {
  return Material(
    child: InkWell(
      onTap: () => navigateToCategory(snapshot, context),
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
        height: 200,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blue,
              blurRadius: 100.0, // has the effect of softening the shadow
              spreadRadius: 0, // has the effect of extending the shadow
              offset: Offset(
                30.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: Card(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(snapshot.data['imageURL']),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Text(
                            snapshot.data['name'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              // color: Colors.white,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 6
                                ..color = Colors.blue[700],
                            ),
                          ),
                          Text(
                            snapshot.data['name'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Stack(
                        children: <Widget>[
                          Text(
                            '>',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              // color: Colors.white,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 6
                                ..color = Colors.blue[700],
                            ),
                          ),
                          Text(
                            '>',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      // Icon(
                      //   Icons.keyboard_arrow_right,
                      //   color: Colors.white,
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
void getUserLocationInfo()async{

  var holder = await Firestore.instance.collection(returnLocationsCollection()).getDocuments();
  doclist = holder.documents;
  await Firestore.instance.collection(returnUserCollection()).document(globals.uid).get().then((DocumentSnapshot ds) async {
    var doc = ds.data;
    globals.isAdmin = doc['Admin'];
    globals.locationManager = doc['LocationManager'];
  });

}

class _ListPageState extends State<ListPage> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   setManager();
  // }

  // Future setManager() {}

  Future getFirestoreData() async {
    final firestore = Firestore.instance;
    print('${globals.organization} ---------------------------');
    QuerySnapshot arrayOfLocationDocuments =
        await firestore.collection(returnLocationsCollection()).getDocuments();
    return arrayOfLocationDocuments.documents;
  }





  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if(globals.isiOS){
      getUserLocationInfo();

      if(doclist != null && doclist.length != 0) {


        return ListView.builder(
            itemCount: doclist.length,
            itemBuilder: (BuildContext context, int index) =>
                customCardios(index, doclist[index], context));
      }else{
        return Container(
          child: FutureBuilder(
            future: getFirestoreData(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) =>
                        customCard(index, snapshot, context));
              }
            },
          ),
        );
      }
    }

    return Container(
      child: FutureBuilder(
        future: getFirestoreData(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) =>
                    customCard(index, snapshot, context));
          }
        },
      ),
    );
  }
}
