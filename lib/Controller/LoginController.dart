

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inedithos_chat/Controller/DialogBoxController.dart';
import 'package:inedithos_chat/Model/FirebaseHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class LoginController extends StatefulWidget {
  LoginControllerState createState() => new LoginControllerState();
}

class LoginControllerState extends State<LoginController>{
  bool _log = true;
  String _mail;
  String _password;
  String _name;
  String _surname;
  bool _obscureText = true;
  String _title = 'Login';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(_title),),
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Container(
              margin: EdgeInsets.all(20.0),

              // padding: EdgeInsets.only(top:30),
              width: MediaQuery.of(context).size.width -40 ,
              height: MediaQuery.of(context).size.height /2,
              child: new Card(
                  elevation: 8.5,
                  child:  new Container(
                    margin :EdgeInsets.only(left:6.0, right:6.0),
                    child:  new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:cardElements(),
                    ),
                  )
              ),
            ),

            new RaisedButton(
              onPressed: _manageLog,
              color: Colors.indigoAccent,
              child: new Text((_log== true)? 'Connectarse':'Registrarse',
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _manageLog(){
    DialogBox dialogBox = DialogBox();
    print('_manageLog  starting');
    if (_mail != null ){
      if ( _password != null){
        if (_log == true){
          // connectarse
          FirebaseHelper().handleSignIn(_mail, _password).then((FirebaseUser user){
            print("tenemos usuario ${user.uid}");
          }).catchError((error) {
            dialogBox.information(context, "Error",error.toString());
          });
        }else {
          if (_name != null) {
            if (_surname!= null){
              //crear cuenta
              FirebaseHelper().handleSignUp(_mail, _password, _name, _surname).then((FirebaseUser user){
                print("Se ha creado el usuario ${user.uid}");
              }).catchError((error) {
                dialogBox.information(context, "Error",error.toString());
              });
            }else {
              //Aviso apellidos
              dialogBox.information(context, "Aviso","Para poder regitrarse, Introduzca sus apellidos");
            }
          } else {
            //Aviso nombre
            dialogBox.information(context, "Aviso","Para poder regitrarse, Introduzca su nombre");
          }
        }
      }else {
        print('_manageLog  pass');

        // Aviso password
        dialogBox.information(context,  "Aviso","No se ha introducido la contraseña");
      }
    }else {
      // Aviso mail
      print('_manageLog  mail');
      dialogBox.information(context, "Aviso", "No se ha introducido el correo");
    }
    print('_manageLog  finishing');
  }
  List<Widget> cardElements () {
    List<Widget> widgets = [];
    widgets.add(
      Container(
        width: MediaQuery.of(context).size.width/1.2,
        //  height: MediaQuery.of(context).size.height/10,
        //   margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/50),
        padding: EdgeInsets.only(
            top: 4,left: 16, right: 16, bottom: 4
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.blue,
                  blurRadius: 5
              )
            ]
        ),
        child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(Icons.email,
                color: Colors.indigoAccent,
              ),
              hintText: 'Email',
            ),
            onChanged: (string){
              setState(() {
                _mail = string;
              });}
        ),
      ),
    );
    widgets.add(
      Container(
        width: MediaQuery.of(context).size.width/1.2,
        //  height: MediaQuery.of(context).size.height/10,
        //  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/50),
        padding: EdgeInsets.only(
            top: 4,left: 16, right: 16, bottom: 4
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.blue,
                  blurRadius: 5
              )
            ]
        ),
        child: new TextField(
            autofocus: false,
            obscureText: _obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(Icons.vpn_key,
                color: Colors.indigoAccent,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  semanticLabel:
                  _obscureText ? 'show password' : 'hide password',
                ),
              ),
              hintText: 'Contraseña',
            ),
            onChanged: (string){
              setState(() {
                _password = string;
              });}
        ),
      ),
    );
    // si no estamos connectados

    if (_log == false){
      widgets.add(
        Container(
          width: MediaQuery.of(context).size.width/1.2,
          //  height: MediaQuery.of(context).size.height/30,
          //margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/50),
          padding: EdgeInsets.only(
              top: 4,left: 16, right: 16, bottom: 4
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5
                )
              ]
          ),
          child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.person_outline,
                  color: Colors.indigoAccent,
                ),
                hintText: 'Nombre',
              ),
              onChanged: (string){
                setState(() {
                  _name = string;
                });}
          ),
        ),
      );
      widgets.add(
        Container(
          width: MediaQuery.of(context).size.width/1.2,
          // height: MediaQuery.of(context).size.height/20,
          //  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/50),
          padding: EdgeInsets.only(
              top: 4,left: 16, right: 16, bottom: 4
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.blue,
                    blurRadius: 5
                )
              ]
          ),
          child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.person_outline,
                  color: Colors.indigoAccent,
                ),
                hintText: 'Apellido',
              ),
              onChanged: (string){
                setState(() {
                  _surname = string;
                });}
          ),
        ),
      );

    }

    widgets.add(
        new FlatButton(
            onPressed: (){
              setState( ( ){
                _log = !_log;
              });
            },
            highlightColor: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 16, right: 32
              ),
              child: new Text(
                (_log == true)
                  ? "¿No tiene cuenta?, pulsa aquí"
                  : "¿Ya tiene cuenta?, pulsa aquí",
                style: TextStyle(
                    color: Colors.black54
                ),
              ),
            )
        )
    );
    return widgets;
  }
}
