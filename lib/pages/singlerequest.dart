import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_auth/widgets/single_news_header.dart';
import 'package:flutter_auth/utils/sendNotify.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleRequest extends StatelessWidget {
  Map<String, dynamic> data;
  String role;
  SingleRequest(Map<String, dynamic> n, String s) {
    data = n;
    role = s;
  }

  deleteBook() async {
    final collection = FirebaseFirestore.instance.collection('books');
    QuerySnapshot querySnap =
        await collection.where("isbn", isEqualTo: data['isbn']).get();
    collection
        .doc(querySnap.docs[0].id) // <-- Doc ID to be deleted.
        .delete() // <-- Delete
        .then((_) => print('Deleted'))
        .catchError((error) => print('Delete failed: $error'));
  }

  likeRequest() async {
    final collection = FirebaseFirestore.instance.collection('requests');
    QuerySnapshot querySnap = await collection
        .where("isbn", isEqualTo: data['isbn'])
        .where('datetake', isEqualTo: data['datetake'])
        .get();
    await collection
        .doc(querySnap.docs[0].id)
        .update({'state': 'подтверждена'});
    await SendNotify.sendAndRetrieveMessage(
        await data['login'], 'Заявка подтверждена');
  }

  endRequest() async {
    final collection = FirebaseFirestore.instance.collection('requests');
    QuerySnapshot querySnap = await collection
        .where("isbn", isEqualTo: data['isbn'])
        .where('datetake', isEqualTo: data['datetake'])
        .get();
    await collection.doc(querySnap.docs[0].id).update({'state': 'закончена'});
    await SendNotify.sendAndRetrieveMessage(
        await data['login'], 'Возврат подтвержден');
  }

  closeRequest() async {
    final collection = FirebaseFirestore.instance.collection('requests');
    QuerySnapshot querySnap =
        await collection.where("isbn", isEqualTo: data['isbn']).get();
    await collection.doc(querySnap.docs[0].id).update({'state': 'отклонена'});
    await SendNotify.sendAndRetrieveMessage(
        await data['login'], 'Заявка отклонена');
  }

  getConnect(BuildContext context) async {
    final collection = FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnap =
        await collection.where("email", isEqualTo: data['owner']).get();
    final u = await collection.doc(querySnap.docs[0].id).get();
    return u['phone'];
  }

  _launchURL(String phone) async {
    String url = 'https://api.whatsapp.com/send?phone=' + phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget getButtons(context) {
    if (role != 'user') if (data['state'] == 'возврат') {
      return Row(
        children: [
          ElevatedButton(
            onPressed: () {
              endRequest();
              Navigator.pop(context);
            },
            child: Text(
              "Принять возврат",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
              ),
            ),
          )
        ],
      );
    } else {
      if (data['state'] == 'закончена') {
        return Text("Завершенная заявка");
      } else if (data['state'] == 'подтверждена') {
        return Text("Книга выдана");
      }
      return Row(
        children: [
          ElevatedButton(
            onPressed: () {
              likeRequest();
              Navigator.pop(context);
            },
            child: Text(
              "Выдать книгу",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              closeRequest();
              Navigator.pop(context);
            },
            child: Text(
              "Отклонить",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
              ),
            ),
          )
        ],
      );
    }
    else {
      return Text(data['state']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 0.0,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SingleNewsHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        data['namebook'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        "Автор заявки " + data['nameuser'],
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
                            color: Color.fromRGBO(233, 233, 233, 1),
                          ),
                          image: DecorationImage(
                            image: this.data["image"] != null
                                ? NetworkImage(this.data["image"])
                                : AssetImage('assets/images/noimage.jpg'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        data['isbn'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        (data['datetake']).toDate().toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        (data['dategive']).toDate().toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      getButtons(context),
                      ElevatedButton(
                          onPressed: () async {
                            dynamic url = await getConnect(context);
                            _launchURL(url);
                          },
                          child: Text("Связаться через WhatsApp")),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
