import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;

class SendNotify {
  static sendAndRetrieveMessage(String login, dynamic title) async {
    final String serverToken =
        'AAAAzNFAJ0k:APA91bEcCg1dR0oMy9RtEsdJBaR04PMMIP54YFK_GTmdxJIVM0wNdhSJuiUYE7SRLbRkH6xPm149P5wVJWcJjJVPBvwUpXxxwxHeI6VVPQzPGfz6a8cw7SUL-wSLEm_tSwaVLY9ttSQs';
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final FirebaseAuth auth = FirebaseAuth.instance;
    final collection = FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnap;
    if (login != null) {
      querySnap = await collection.where('email', isEqualTo: login).get();
    } else {
      querySnap = await collection
          .where('email', isEqualTo: auth.currentUser.email)
          .get();
    }

    final _db = await collection.doc(querySnap.docs[0].id).get();

    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Откройте приложение',
            'title': title
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': _db['fcm'],
        },
      ),
    );
  }
}
