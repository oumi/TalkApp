import 'package:flutter/material.dart';
import 'package:inedithos_chat/Model/Message.dart';
import 'package:inedithos_chat/Model/User.dart';
import 'package:inedithos_chat/Widgets/CustomImage.dart';
import 'package:inedithos_chat/Widgets/CustomPdf.dart';
import 'dart:math';

/*
* Draw the chat bubble of every conversation
 */
class ChatBubble extends StatelessWidget{
  Message message;
  User partner;
  String myId;
  Animation animation;

  ChatBubble(String id, User partner, Message message, Animation animation){
    this.myId= id;
    this.partner= partner;
    this.message = message;
    this.animation= animation;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizeTransition(
      sizeFactor: new CurvedAnimation(parent: animation, curve: Curves.easeIn),
      child: new Container(
          margin: EdgeInsets.all(10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: widgetsBubble(message.from == myId),
          )
      ),
    );
  }

/*
* In this list of chatBubbles, we distinguish between the current user and the partner
* the color of the bubble and the position of the text changes depending on who is sending
 */
  List<Widget> widgetsBubble(bool me){
    CrossAxisAlignment alignment = (me)? CrossAxisAlignment.end : CrossAxisAlignment.start;
    Color bubbleColor = (me)? Colors.green[200]: Colors.blue[300];
    Color textColor =(me)? Colors.black: Colors.grey[200];

    return <Widget>[
      me ? new Padding(padding: EdgeInsets.all(10.0)): new CustomImage(partner.imageUrl, partner.initiales, 20.0),
      new Expanded(
          child: new Column(
            crossAxisAlignment: alignment,
            children: <Widget>[
              new Text(message.dateString),
              new Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10.0)),
                color: bubbleColor,
                child:new Container(
                    padding: EdgeInsets.all(10.0),
                    child:
                     (message.imageUrl == null)
                        ? ((message.fileUrl == null)
                        ? new Text(
                          message.text ?? "",
                          style: new TextStyle(
                              color: textColor,
                              fontSize: 15.0,
                              fontStyle: FontStyle.italic
                            ),
                          )
                        : new CustomPdf(message.fileUrl)
                    )
                        : new CustomImage(message.imageUrl, null, null)
                ),
              )
            ],
          )
      )
    ];
  }

}