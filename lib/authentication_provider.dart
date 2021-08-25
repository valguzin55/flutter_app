import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class AuthenticationProvider {
  final FirebaseAuth firebaseAuth;
  static FirebaseFirestore _db = FirebaseFirestore.instance;
  AuthenticationProvider(this.firebaseAuth);

  Stream<User> get authState => firebaseAuth.idTokenChanges();

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<String> signIn(String email, String password, context) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      String fcm;
      await FirebaseMessaging.instance
          .getToken()
          .then((value) => fcm = value.toString());
      final userRef = _db.collection("users").doc(firebaseAuth.currentUser.uid);
      await userRef.update({
        "fcm": fcm,
      });

      return "Signed in";
    } catch (e) {
      authProblems errorType;
      if (Platform.isAndroid) {
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorType = authProblems.UserNotFound;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Пользователь не найден"),
            ));
            break;
          case 'The password is invalid or the user does not have a password.':
            errorType = authProblems.PasswordNotValid;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Неправильный пароль"),
            ));
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            errorType = authProblems.NetworkError;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Ошибка сети"),
            ));
            break;
          // ...
          default:
            print('Case ${e.message} is not yet implemented');
        }
      } else if (Platform.isIOS) {
        switch (e.code) {
          case 'Error 17011':
            errorType = authProblems.UserNotFound;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Пользователь не найден"),
            ));
            break;
          case 'Error 17009':
            errorType = authProblems.PasswordNotValid;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Неправильный пароль"),
            ));
            break;
          case 'Error 17020':
            errorType = authProblems.NetworkError;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Ошибка сети"),
            ));
            break;
          // ...
          default:
            print('Case ${e.message} is not yet implemented');
        }
      }
      print('The error is $errorType');
    }
    return 'work';
  }

  Future<dynamic> signUp(
      String email, String password, String name, String phone) async {
    try {
      await Firebase.initializeApp();

      await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) async {
        await user.user.updateDisplayName(name);

        await user.user.reload();
      });
      UserHelper.saveUser(firebaseAuth.currentUser, phone);

      return "Sign in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> uid() async {
    return firebaseAuth.currentUser.uid;
  }
}

class UserHelper {
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static saveUser(User user, String phone) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);
    String fcm;
    await FirebaseMessaging.instance
        .getToken()
        .then((value) => fcm = value.toString());
    Map<String, dynamic> userData = {
      "name": user.displayName,
      "email": user.email,
      "phone": phone,
      "last_login": user.metadata.lastSignInTime.millisecondsSinceEpoch,
      "created_at": user.metadata.creationTime.millisecondsSinceEpoch,
      "role": "user",
      "build_number": buildNumber,
      "fcm": fcm,
    };
    final userRef = _db.collection("users").doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        "last_login": user.metadata.lastSignInTime.millisecondsSinceEpoch,
        "build_number": buildNumber,
      });
    } else {
      await _db.collection("users").doc(user.uid).set(userData);
    }
    await _saveDevice(user);
  }

  static _saveDevice(User user) async {
    DeviceInfoPlugin devicePlugin = DeviceInfoPlugin();
    String deviceId;
    Map<String, dynamic> deviceData;
    if (Platform.isAndroid) {
      final deviceInfo = await devicePlugin.androidInfo;
      deviceId = deviceInfo.androidId;
      deviceData = {
        "os_version": deviceInfo.version.sdkInt.toString(),
        "platform": 'android',
        "model": deviceInfo.model,
        "device": deviceInfo.device,
      };
    }
    if (Platform.isIOS) {
      final deviceInfo = await devicePlugin.iosInfo;
      deviceId = deviceInfo.identifierForVendor;
      deviceData = {
        "os_version": deviceInfo.systemVersion,
        "device": deviceInfo.name,
        "model": deviceInfo.utsname.machine,
        "platform": 'ios',
      };
    }
    final nowMS = DateTime.now().toUtc().millisecondsSinceEpoch;
    final deviceRef = _db
        .collection("users")
        .doc(user.uid)
        .collection("devices")
        .doc(deviceId);
    if ((await deviceRef.get()).exists) {
      await deviceRef.update({
        "updated_at": nowMS,
        "uninstalled": false,
      });
    } else {
      await deviceRef.set({
        "updated_at": nowMS,
        "uninstalled": false,
        "id": deviceId,
        "created_at": nowMS,
        "device_info": deviceData,
      });
    }
  }
}
