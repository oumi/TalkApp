import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:inedithos_chat/Model/Conversation.dart';
import 'package:inedithos_chat/Model/FirebaseHelper.dart';
import 'package:inedithos_chat/Widgets/CustomImage.dart';
import 'package:inedithos_chat/Controller/ChatController.dart';
import 'package:inedithos_chat/lang/cas.dart';

class MessagesController extends StatefulWidget{
  String id ;
  MessagesController(String id ){
    this.id= id;
  }
  MessagesControllerState createState() => new MessagesControllerState();

}

class MessagesControllerState extends State<MessagesController>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  new FirebaseAnimatedList(
      query: FirebaseHelper().base_conversation.child(widget.id),
      sort: (a,b)=>  b.value["dateString"].compareTo(a.value["dateString"]),
      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
        Conversation conversation = new Conversation(snapshot);
        String subtitle = (conversation.id == widget.id)? cas_text_yo+": " : "";
        subtitle += conversation.last_message ?? cas_text_file_sent;
        return new ListTile(
          leading: new CustomImage(conversation.user.imageUrl, conversation.user.initiales, 20.0),
          title: new Text("${conversation.user.name}  ${conversation.user.surname}"),
          subtitle: new Text(subtitle),
          trailing: new Text(conversation.date),
          onTap: (){
            Navigator.push(context, new MaterialPageRoute(builder: (context)=> new ChatController(widget.id, conversation.user)));
          },
        );

      },
    );
  }
}