import 'package:flutter/material.dart';
import 'package:inedithos_chat/Model/User.dart';
import 'package:inedithos_chat/Model/FirebaseHelper.dart';
import 'package:inedithos_chat/Widgets/CustomImage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:inedithos_chat/Widgets/DialogBox.dart';
import 'package:inedithos_chat/Widgets/Const.dart';


class ProfileController extends StatefulWidget{
  String id ;

  var _controller = TextEditingController();

  ProfileController(String id ){
    this.id= id;
  }
  ProfileControllerState createState() => new ProfileControllerState();

}

class ProfileControllerState extends State<ProfileController>{
  User user;
  String name;
  String surname;
  final FocusNode focusNodeName = new FocusNode();
  final FocusNode focusNodeSurname = new FocusNode();

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
        ? new Center(
      child: new Text(
        "Cargando ...",
        style: new TextStyle(
            fontSize: 30.0,
            fontStyle: FontStyle.italic,
            color: teal400
        ),
      ),
    )
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
              focusNode: focusNodeName,
            ),
            new TextField(
              decoration: new InputDecoration(
                  hintText: user.surname
              ),
              onChanged: (string){
                setState(() {
                  surname = string;
                });
              },
              focusNode: focusNodeSurname,
            ),
            new SizedBox(height: 30.0),
            new RaisedButton(
              padding: EdgeInsets.all(10.0),
              color: teal400,
              onPressed: _saveChanges,
              child: new Text ("Guardar cambios", style: new TextStyle(color: Colors.white, fontSize: 20.0),),
            ),


          ],
        ),
      ),
    );

  }
  _saveChanges(){
    focusNodeName.unfocus();
    focusNodeSurname.unfocus();
    DialogBox dialogBox = DialogBox();
    bool _nameChanged = false;
    bool _surnameChanged = false;
    Map map = user.toMap();
    if (surname!= null) {
      map["surname"] = surname;
      _surnameChanged = true;
    }
    if (name != null && name != "" ){
      map["name"] = name;
      _nameChanged = true;
    }
    FirebaseHelper().addUser(user.id, map);
    _getUser();
    if (_nameChanged || _surnameChanged) {
      dialogBox.information(
          context, "Cambios guardados",
          'Los cambios han sido guardados correctamente!');
    }
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

