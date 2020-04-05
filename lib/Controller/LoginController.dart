import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inedithos_chat/Widgets/DialogBox.dart';
import 'package:inedithos_chat/Model/FirebaseHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inedithos_chat/Widgets/Const.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:inedithos_chat/Model/FirebaseNotifications.dart';
import 'package:inedithos_chat/Widgets/Loading.dart';
import 'package:inedithos_chat/lang/cas.dart';


/*
* Class to draw the Login and sign up controller
 */
class LoginController extends StatefulWidget {
  LoginControllerState createState() => new LoginControllerState();
}

class LoginControllerState extends State<LoginController>{
  bool _log = true;
  String _mail;
  String _password;
  String _name;
  String _surname;
  bool _obscureText = true;// show or hide the password
  String _title = appName;
  String _role ;
  String _token ;
  bool loading = false;

  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var android = new AndroidInitializationSettings('logo');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);

    firebaseMessaging.configure(
        onLaunch: (Map<String , dynamic> msg){
          print("onLaunch called ${(msg)}");
          showNotification(msg);

        },
        onResume: (Map<String , dynamic> msg){
          print("onResume called ${(msg)}");
          showNotification(msg);

        },
        onMessage:  (Map<String , dynamic> msg){
          print("onResume called ${(msg)}");
          showNotification(msg);
        }
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true , alert: true ,badge: true));

    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting){
      print("onIosSettingsRegistered");
    });
    firebaseMessaging.getToken().then((token){
      _token = token;
      //save_token(token);
    });
  }

  showNotification(Map<String , dynamic> msg) async{
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
    print (msg);
    await flutterLocalNotificationsPlugin.show(0, msg['notification']['title'],
        msg['notification']['body'],
        platform);

  }
  /////////////////////////////////////////////////////////







  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : new Scaffold(
      appBar: new AppBar(title: new Text(_title),),
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Container(
              margin: EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width -40 ,
              height: MediaQuery.of(context).size.height /1.5,
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
              color: teal400,
              child: new Text((_log== true)? cas_text_signIn:cas_text_signUp,
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
    if (_mail != null ){
      if ( _password != null){
        if (_log == true){
          // connecting
          loading=true;
          FirebaseHelper().handleSignIn(_mail, _password, _token).then((FirebaseUser user){
            print("tenemos usuario ${user.uid}");
          }).catchError((error) {
            loading=false;
            dialogBox.information(context, cas_error,cas_error_invalidEmailOrPassword);
          });
        }else {
          if (_name != null) {
            if (_surname!= null){
              if (_role!= null  || _role =='') {
                //crear cuenta
                FirebaseHelper()
                    .handleSignUp(_mail, _password, _name, _surname, _role, _token)
                    .then(( FirebaseUser user ) {
                  print("Se ha creado el usuario ${user.uid}");
                }).catchError(( error ) {
                  dialogBox.information(context, cas_error, cas_error_invalidEmail);
                });
              }else {
                //Aviso rol
                dialogBox.information(context, cas_warning, cas_warning_noRole);
              }
            }else {
              //Aviso apellidos
              dialogBox.information(context, cas_warning,cas_warning_noSurname);
            }
          } else {
            //Aviso nombre
            dialogBox.information(context, cas_warning,cas_warning_noName);
          }
        }
      }else {
        // Aviso password
        dialogBox.information(context,  cas_warning,cas_warning_noPassword);
      }
    }else {
      // Aviso mail
      print('_manageLog  mail');
      dialogBox.information(context, cas_warning, cas_warning_noMail);
    }

  }
  List<Widget> cardElements () {
    List<Widget> widgets = [];
    widgets.add(
      // If we have an account already, show email and password
      Container(
        width: MediaQuery.of(context).size.width/1.2,
        padding: EdgeInsets.all(4),
             decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: teal400,
                  blurRadius: blurRad
              )
            ]
        ),
        child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(Icons.email,
                color: teal400,
              ),
              hintText: cas_text_email,
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
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: teal400,
                  blurRadius: blurRad
              )
            ]
        ),
        child: new TextField(
            autofocus: false,
            obscureText: _obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(Icons.vpn_key,
                color: teal400,
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
              hintText: cas_text_password,
            ),
            onChanged: (string){
              setState(() {
                _password = string;
              });}
        ),
      ),
    );
    // If we don't have an account, show more textfields to sign up
    if (_log == false){
      widgets.add(
        Container(
          width: MediaQuery.of(context).size.width/1.2,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: teal400,
                    blurRadius: blurRad
                )
              ]
          ),
          child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.person_outline,
                  color: teal400,
                ),
                hintText: cas_text_name,
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
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: teal400,
                    blurRadius: blurRad
                )
              ]
          ),
          child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.person_outline,
                  color: teal400,
                ),
                hintText: cas_text_surname,
              ),
              onChanged: (string){
                setState(() {
                  _surname = string;
                });}
          ),
        ),
      );

      widgets.add(
        Container(
          width: MediaQuery.of(context).size.width/1.2,
          // height: MediaQuery.of(context).size.height/20,
          //  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/50),
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: teal400,
                    blurRadius: blurRad
                )
              ]
          ),
          child: new DropdownButtonHideUnderline(
            child:DropdownButton(
              items: defaultRoles.map((String value) {
                return new DropdownMenuItem(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
            onChanged: (String newValue) {
              setState(() {
                _role = newValue;
               // state.didChange(newValue);
              });
            },

              hint: Text('  '+cas_text_role),
              value: _role,
              isDense: true,
          ),),
        ),
      );
    }
    //Switch between the 2 screens: login and sign up
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
                  ? cas_text_noAccountYet + cas_text_pressHere
                  :  cas_text_haveAccount + cas_text_pressHere,
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
