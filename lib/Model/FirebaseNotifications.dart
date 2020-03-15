import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';


class FirebaseNotifications {
  String _token;
  //Initialise the settings of local notificactions and firebase messagings
  // return the token of the device to be saved when the user sign up


  void localNotificationsSettings(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin){
    var android = new AndroidInitializationSettings('logo');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);
  }

  String initialise(FirebaseMessaging firebaseMessaging, flutterLocalNotificationsPlugin){
 //   localNotificationsSettings();
    _token =firebaseListeners(firebaseMessaging,flutterLocalNotificationsPlugin );
    return _token;
  }

  String firebaseListeners(FirebaseMessaging firebaseMessaging, flutterLocalNotificationsPlugin){
    if (Platform.isIOS) iOS_Permission(firebaseMessaging);
    firebaseMessaging.getToken().then((token) {
      _token = token;
      print(token);
    });
    firebaseMessaging.configure(
      // Called when the App is in Foreground and we receive a push notif
      onMessage:(Map<String, dynamic> message) async{
        print('onMessage: $message');
        showNotification(message, flutterLocalNotificationsPlugin);

      },
      // Called when the App has been closed and it's opened from the push notif
      onLaunch:(Map<String, dynamic> message) async{
        print('onMessage: $message');
        showNotification(message,  flutterLocalNotificationsPlugin);
      },
      //Called when the app is in background and it's opened from the push notif
      onResume:(Map<String, dynamic> message) async{
        print('onMessage: $message');
        showNotification(message, flutterLocalNotificationsPlugin);
      },
    );
    return _token;
  }

  showNotification(Map<String , dynamic> message, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async{
    var android = new AndroidNotificationDetails(
        "1", "channelName", "channelDescription");
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android,iOS);

    // msg.forEach((k,v){
    //   title = k;
    //   body = v;
    //   setState(() {

    //   });
    // });
    print (message);
    await flutterLocalNotificationsPlugin.show(0, message['notification']['title'],
        message['notification']['body'],
        platform);
  }

  void iOS_Permission(FirebaseMessaging firebaseMessaging) {
    firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  }
