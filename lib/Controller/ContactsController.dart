import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:inedithos_chat/Controller/ChatController.dart';
import 'package:inedithos_chat/Model/FirebaseHelper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:inedithos_chat/Model/User.dart';
import 'package:inedithos_chat/Widgets/CustomImage.dart';
import 'package:inedithos_chat/Widgets/Const.dart';



class ContactsController extends StatefulWidget{
  String id ;
  ContactsController(String id ){
    this.id= id;
  }
  ContactsControllerState createState() => new ContactsControllerState();

}

class ContactsControllerState extends State<ContactsController> {
  User currentUser;
  @override
  void initState( ) {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  @override
  Widget build( BuildContext context ) {
    return (currentUser == null)
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
    // get only the users that have the same role than the current one
   // return
     :new FirebaseAnimatedList(
          query: FirebaseHelper().base_user.orderByChild("role").equalTo(currentUser.role),
          //FirebaseHelper().getRole(widget.id)
          sort: ( a, b ) => a.value['name'].toString().toLowerCase().compareTo(
              b.value['name'].toString().toLowerCase()),
          itemBuilder: ( BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index ) {
            User newUser = new User(snapshot);
            if (newUser.id == widget.id) {
              //usuario actual
              return new Container();
            } else {
              return new ListTile(
                leading: new CustomImage(
                    newUser.imageUrl, newUser.initiales, 20.0),
                title: new Text("${newUser.name} ${newUser.surname}"),
                subtitle: new Text((newUser.role == null)
                    ? ""
                    : "${newUser.role}"
                    , style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54)
                ),

                trailing: new IconButton(
                  icon: new Icon(Icons.message), onPressed: ( ) {
                  //chatear con este usuario
                  Navigator.push(context, new MaterialPageRoute(
                      builder: ( context ) => new ChatController (
                          widget.id, newUser)));
                },),
              );
            }
          }
      );
  }

  _getUser( ) {
    FirebaseHelper().getUser(widget.id).then(( user ) {
      if (this
          .mounted) { //this solution is used to solve the problem: Unhandled Exception: setState() called after dispose(): ProfileControllerState#25e81(lifecycle state: defunct, not mounted)
        setState(( ) {
          this.currentUser = user;
        });
      }
    });
  }

}