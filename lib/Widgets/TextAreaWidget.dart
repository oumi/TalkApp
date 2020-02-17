import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:inedithos_chat/Model/FirebaseHelper.dart';
import 'package:inedithos_chat/Model/User.dart';
import 'dart:io';
import 'dart:async';


class TextAreaWidget extends StatefulWidget{
  User partner;
  String id;

  TextAreaWidget(User partner, String id){
    this.id = id;
    this.partner = partner;
  }

  AreaState createState () => new AreaState();
}

class AreaState extends State<TextAreaWidget>{

  TextEditingController _textEditingController = new TextEditingController();
  User me;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseHelper().getUser(widget.id).then((user){
      if (this.mounted) {
        setState(( ) {
          me = user;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      color: Colors.grey[250],
      padding: EdgeInsets.all(5.0),
      child: new Row(
        children: <Widget>[
          new IconButton(icon: new Icon(Icons.camera_enhance),  tooltip: 'Change Color',  onPressed: ()=> takePicture(ImageSource.camera) ),
          new IconButton(icon: new Icon(Icons.photo_library),   tooltip: 'Change Color', onPressed: ()=> takePicture(ImageSource.gallery) ),
          new IconButton(icon: new Icon(Icons.attach_file),   tooltip: 'Change Color', onPressed: atachFile),
          new Flexible(
            child: new TextField(
              controller: _textEditingController,
              decoration: new InputDecoration.collapsed(hintText: "Escirbir algo..."),
              maxLines: null,
            ),
          ),
          new IconButton(icon: new Icon(Icons.send),  tooltip: 'Change Color', onPressed: _sendButtonPressed),
        ],
      ),
    );
  }

  _sendButtonPressed() {
    if (_textEditingController.text != null && _textEditingController.text != ""){
      String text = _textEditingController.text;
      FirebaseHelper().sendMessage(widget.partner, me, text, null, null);
      _textEditingController.clear();
      FocusScope.of(context).requestFocus(new FocusNode());
    }else {
      print ("No hay texto");
    }
  }

  Future<void> takePicture(ImageSource source) async{
    print('entro ');
    File file = await ImagePicker.pickImage(source: source, maxWidth: 1000.0, maxHeight: 1000.0);
    String date = new DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseHelper().saveFile(file, FirebaseHelper().storage_message.child(widget.id).child(date)).then((string){
      print('hola');
      FirebaseHelper().sendMessage(widget.partner, me, null, string, null);
    });
  }

  Future<void> atachFile() async{
    File file = await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: 'pdf');
    if (file != null) {
      String date = new DateTime.now().millisecondsSinceEpoch.toString();
      date = date+'_'+file.path.split('/').last;
      print(date);
      FirebaseHelper().saveFile(file, FirebaseHelper().storage_message.child(widget.id).child(date))
          .then(( string ) {
            print('string');
        FirebaseHelper().sendMessage(widget.partner, me, null, null, string);
      });
    }

  }
}