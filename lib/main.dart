import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Controller/LoginController.dart';
import 'Controller/MainController.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat App Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: _manageAuth(),
    );
  }


  Widget _manageAuth(){
    return new StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot){
          if (snapshot.hasData) {
            //connectado
            return new MainController();
          }else{
            //no connectado
            return new LoginController();

          }
        }
    );
  }

}

