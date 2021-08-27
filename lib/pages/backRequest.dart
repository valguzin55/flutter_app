import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_auth/pages/notFoundPage.dart';
import 'package:flutter_auth/pages/success.dart';
import 'package:flutter_auth/utils/sendNotify.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class BackRequest extends StatefulWidget {
  String isbn;
  DateTime date = DateTime.now().add(Duration(days: 30));
  BackRequest({String isbn}) {
    this.isbn = isbn;
  }

  @override
  _BackRequest createState() => _BackRequest();
}

class _BackRequest extends State<BackRequest> {
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  Future data;
  @override
  void initState() {
    super.initState();
    data = getDataFirebase(widget.isbn);
  }

  Future<dynamic> getDataFirebase(String isbn) async {
    final String _collection = 'books';

    dynamic val = await _db.collection(_collection).get();
    for (var i in val.docs) {
      if (i.data()['isbn'] == isbn) {
        return i.data();
      }
    }
  }

  backRequest(dynamic data) async {
    //print(data['login']);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final collection = FirebaseFirestore.instance.collection('requests');
    QuerySnapshot querySnap = await collection
        .where("isbn", isEqualTo: data['isbn'])
        .where("login", isEqualTo: auth.currentUser.email)
        .where("state", isEqualTo: "подтверждена")
        .get();
    if (querySnap.docs.isNotEmpty) {
      collection.doc(querySnap.docs[0].id).update({'state': 'возврат'});
      await SendNotify.sendAndRetrieveMessage(
          await data['login'], 'Заявка на возврат');
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SuccesScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Заявка по данному ISBN не найдена"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Подтвердить возврат"),
        ),
        body: FutureBuilder<dynamic>(
            future: getDataFirebase(
                widget.isbn), // function where you call your api
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              // AsyncSnapshot<Your object type>
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator()));
              } else {
                if (snapshot.hasError)
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                else {
                  if (snapshot.hasData) {
                    return Scaffold(
                      resizeToAvoidBottomInset: false,
                      body: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(
                                        height: 30.0,
                                      ),
                                      Text(
                                        snapshot.data['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data['author'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Container(
                                        height: ScreenUtil().setHeight(200),
                                        width: ScreenUtil().setWidth(200),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color.fromRGBO(
                                                233, 233, 233, 1),
                                          ),
                                          image: DecorationImage(
                                            image: snapshot.data["image"] !=
                                                    null
                                                ? NetworkImage(
                                                    snapshot.data["image"])
                                                : AssetImage(
                                                    'assets/images/noimage.jpg'),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              "isbn:  ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data['isbn'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "Дата сдачи",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Text(
                                        widget.date.day.toString() +
                                            ' ' +
                                            widget.date.month.toString() +
                                            ' ' +
                                            widget.date.year.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            backRequest(snapshot.data);
                                          },
                                          child: Text("Подтвердить возврат"))
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return NotFoundPage();
                  }
                }
              }
            }));
  }
}
