import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'models/constants.dart';

import 'data_classes/firebase_connection.dart';
import 'data_classes/item_firebase_services.dart';
import 'edit_item.dart';

class ItemsListFiltered extends StatefulWidget {
  String? fil;
  ItemsListFiltered({Key? key, this.fil}) : super(key: key);

  @override
  State<ItemsListFiltered> createState() => _ItemsListFilteredState(fil: fil);
}

class _ItemsListFilteredState extends State<ItemsListFiltered> {
  String? fil; // fil is filter catch from items_list_category_filter.dart
  _ItemsListFilteredState({this.fil});

  displayMessage(String msge) {
    Fluttertoast.showToast(
      msg: msge,
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.white,
      backgroundColor: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 25,
        ),
        //centerTitle: true,
        title: const Text(
          "Filterd Items List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      //drawer: sdrawer(context),
      body: Container(
        padding: const EdgeInsets.only(top: 15, left: 5, right: 5, bottom: 5),
        child: StreamBuilder(
            stream: firebasefirestore
                .collection('items')
                .where('mail', isEqualTo: constants.mail)
                .where('category', isEqualTo: fil)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.docs.isNotEmpty
                    ? ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final res = snapshot.data!.docs[index];
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (v) {
                              ItemOperation.deleteItem(res.id);
                              displayMessage("Item Deleted");
                            },
                            background: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            child: Card(
                              color: const Color.fromARGB(255, 73, 155, 100),
                              elevation: 6,
                              child: ExpansionTile(
                                title: Text(
                                  "${res['name']}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                leading: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditItem(
                                          id: res.id,
                                          cateory: res['category'],
                                          name: res['name'],
                                          desc: res['description'],
                                          price: res['price'].toString(),
                                          imgurl: res['url'],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.orange, width: 2),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            color: Colors.orange,
                                            child: Text(
                                              "${res['price']}",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 10,
                                          ),
                                          child: Text(
                                            "${res['description']}  |",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 10,
                                          ),
                                          child: Text(
                                            "${res['category']}  |",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "No item exsists in '" +
                                fil.toString() +
                                "' category ",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 149, 155, 165)),
                          ),
                        ),
                      );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                );
              }
            }),
      ),
    );
  }
}
