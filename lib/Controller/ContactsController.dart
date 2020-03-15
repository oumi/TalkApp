import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:inedithos_chat/Controller/ChatController.dart';
import 'package:inedithos_chat/Model/FirebaseHelper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:inedithos_chat/Model/User.dart';
import 'package:inedithos_chat/Widgets/CustomImage.dart';
import 'package:inedithos_chat/Widgets/Loading.dart';

/*
* Controller to draw and manage the screen contacts
 */

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
        ? Loading()
    // get only the users that are at the same room than the current one
     :new FirebaseAnimatedList(
          query: FirebaseHelper().base_user.orderByChild("room").equalTo(currentUser.room),
          //FirebaseHelper().getRole(widget.id)
          sort: ( a, b ) => a.value['name'].toString().toLowerCase().compareTo(
              b.value['name'].toString().toLowerCase()),
          itemBuilder: ( BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index ) {
            User newUser = new User(snapshot);
            // show users
            if (newUser.id == widget.id) {
              //We don't have to chow the current user in the list of contacts
              return new Container();
            } else {
              return new ListTile(
                leading: new CustomImage(
                    newUser.imageUrl, newUser.initiales, 20.0),
                title: new Text("${newUser.name} ${newUser.surname}"),
                subtitle: new Text((newUser.role == null )
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