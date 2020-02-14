import 'package:flutter/material.dart';
import 'package:inedithos_chat/Model/User.dart';
import 'package:inedithos_chat/Model/FirebaseHelper.dart';
import 'package:inedithos_chat/Widgets/CustomImage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class ProfileController extends StatefulWidget{
  String id ;
  ProfileController(String id ){
    this.id= id;
  }
  ProfileControllerState createState() => new ProfileControllerState();

}

class ProfileControllerState extends State<ProfileController>{
  User user;
  String name;
  String surname;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (user == null)
        ? new Center(child: new Text("Cargando ..."))
        : new SingleChildScrollView(
      child: new Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //imagen
            new CustomImage(user.imageUrl, user.initiales, MediaQuery.of(context).size.width/5),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.camera_enhance),
                    onPressed: (){
                      _takePicture(ImageSource.camera);
                    }),
                new IconButton(
                    icon: new Icon(Icons.photo_library),
                    onPressed: (){
                      _takePicture(ImageSource.gallery);
                    }),
              ],
            ),
            new TextField(
              decoration: new InputDecoration(hintText: user.name),
              onChanged: (string){
                setState(() {
                  name = string;
                });
              },
            ),
            new TextField(
              decoration: new InputDecoration(hintText: user.surname),
              onChanged: (string){
                setState(() {
                  surname = string;
                });
              },
            ),
            new RaisedButton(
              padding: EdgeInsets.all(10.0),
              color: Colors.indigoAccent,
              onPressed: _saveChanges,
              child: new Text ("Guardar cambios", style: new TextStyle(color: Colors.white, fontSize: 20.0),),
            ),
            new FlatButton(
              onPressed: (){
                _logOut(context);
              },
              child: new Text ("Cerrar sesión", style: new TextStyle(color: Colors.indigoAccent, fontSize: 20.0),),
            )
          ],
        ),
      ),
    );

  }
  _saveChanges(){
    Map map = user.toMap();
    if (surname!= null) {
      map["surname"] = surname;
    }
    if (name != null && name != "" ){
      map["name"] = name;
    }
    FirebaseHelper().addUser(user.id, map);
    _getUser();
  }

  Future<void> _takePicture(ImageSource source) async{
    File image = await ImagePicker.pickImage(source: source, maxHeight: 400.0, maxWidth: 400.0);
    //Obtener una url despues de haber añadido la imagen en el stock
    FirebaseHelper().saveFile(image, FirebaseHelper().storage_users.child(widget.id)).then((string){
      Map map = user.toMap();
      map["imageUrl"] = string;
      FirebaseHelper().addUser((user.id), map);
      _getUser();
    });
  }

  Future<void> _logOut(BuildContext context) async{
    Text title = new Text("Cerrar sesión");
    Text subtitle = new Text("Seguro que desea cerrar la sesión");
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext build){
          return (Theme.of(context).platform == TargetPlatform.iOS )
              ? new CupertinoAlertDialog(title: title, content: subtitle, actions: _actions(build),)
              : new AlertDialog(title: title, content: subtitle, actions: _actions(build));
        }
    );
  }

  List<Widget> _actions (BuildContext build){
    List<Widget> widgets = [];
    widgets.add(new FlatButton(
        onPressed:(){
          FirebaseHelper().handleLogOut().then((bool){
            Navigator.of(build).pop();
          });
        },
        child: new Text("SI"))
    );
      widgets.add(new FlatButton(
        onPressed: ()=> Navigator.of(build).pop(),
        child: new Text("NO"))
    );
    return widgets;
  }

  _getUser() {
    FirebaseHelper().getUser(widget.id).then((user) {
      if (this.mounted){ //this solution is used to solve the problem: Unhandled Exception: setState() called after dispose(): ProfileControllerState#25e81(lifecycle state: defunct, not mounted)
      setState(( ) {
        this.user = user;
      });
    }
    });
  }

  }

