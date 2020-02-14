import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:inedithos_chat/Controller/ChatController.dart';
import 'package:inedithos_chat/Model/FirebaseHelper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:inedithos_chat/Model/User.dart';
import 'package:inedithos_chat/Widgets/CustomImage.dart';


class ContactsController extends StatefulWidget{
  String id ;
  ContactsController(String id ){
    this.id= id;
  }
  ContactsControllerState createState() => new ContactsControllerState();

}

class ContactsControllerState extends State<ContactsController>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  new FirebaseAnimatedList(
        query: FirebaseHelper().base_user,
        sort: (a, b)=> a.value["name"].compareTo(b.value["name"]),
        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
          User newUser = new User(snapshot);
          if (newUser.id == widget.id){
            //usuario actual
            return new Container();
          }else {
            return new ListTile(
                leading: new CustomImage(newUser.imageUrl, newUser.initiales, 20.0),
                title: new Text("${newUser.name} ${newUser.name}"),
                trailing: new IconButton(icon: new Icon(Icons.message), onPressed: (){
                  //chatear con este usuario
                  Navigator.push(context, new MaterialPageRoute(builder:(context)=> new ChatController (widget.id, newUser)));
                },)
            );
          }
        }
    );
  }
}