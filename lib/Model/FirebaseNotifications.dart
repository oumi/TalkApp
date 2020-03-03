import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;

  Future intialise(){
    _firebaseMessaging = FirebaseMessaging();
    firebaseListeners();
  }
  void firebaseListeners(){
    if (Platform.isIOS) iOS_Permission();
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });
    _firebaseMessaging.configure(
      // Called when the App is in Foreground and we receive a push notif
      onMessage:(Map<String, dynamic> message) async{
        print('onMessage: $message');
      },
      // Called when the App has been closed and it's opened from the push notif
      onLaunch:(Map<String, dynamic> message) async{
        print('onMessage: $message');
      },
      //Called when the app is in background and it's opened from the push notif
      onResume:(Map<String, dynamic> message) async{
        print('onMessage: $message');
      },
    );
  }
  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  }
