import 'package:flutter/material.dart';
import 'package:inedithos_chat/Model/User.dart';
import 'package:inedithos_chat/Widgets/CustomImage.dart';
import 'package:inedithos_chat/Widgets/TextAreaWidget.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:inedithos_chat/Model/FirebaseHelper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:inedithos_chat/Model/Message.dart';
import 'package:inedithos_chat/Widgets/ChatBubble.dart';

class ChatController extends StatefulWidget{

  String id;
  User partner;

  ChatController(String id, User partner){
  this.id = id;
  this.partner = partner;
}

ChatControllerState createState() => new ChatControllerState();

}

class ChatControllerState extends State<ChatController>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(title: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children : <Widget>[
          new CustomImage(widget.partner.imageUrl, widget.partner.initiales, 20.0),
          new Text(widget.partner.name)
        ],
      ),
      ),
      body: new Container(
        child: new InkWell(
          onTap: ()=>FocusScope.of(context).requestFocus(new FocusNode()),
          child: new Column(
            children: <Widget>[
              //Zona de chat
              new Flexible(child: new FirebaseAnimatedList(
                  query: FirebaseHelper().base_message.child(FirebaseHelper().getMessageRef(widget.id, widget.partner.id)),
                  sort: (a,b) => b.key.compareTo(a.key),// Ir a la ultima linea de chat
                  reverse: true,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index ){
                    Message message = new Message(snapshot);
                    print (message.text);
                    return new ChatBubble(widget.id, widget.partner, message, animation);
                  })
              ),
              //Divisor
              new Divider (height:1.5),
              //Zona de texto
              new TextAreaWidget(widget.partner, widget.id)
            ],
          )
        ),
      ),

    );
  }
}