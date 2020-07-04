import 'package:firebase_database/firebase_database.dart';
import 'package:inedithos_chat/Model/DateHelper.dart';
import 'package:inedithos_chat/Model/User.dart';
//import 'package:inedithos_chat/Model/Conversation.dart';

class Conversation {

String id;
String last_message;
User user;
String date ;
String state;

//User user;
Conversation(DataSnapshot snapshot){
 this.id = snapshot.value["myId"];
 String stringDate = snapshot.value["dateString"];
 this.date = DateHelper().getDate(stringDate);
 this.last_message = snapshot.value["last_message"];
 this.state = snapshot.value["state"];
 this.user = new User(snapshot);
}

}