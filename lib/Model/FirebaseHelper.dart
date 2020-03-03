import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import'package:inedithos_chat/Model/User.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io' ;
import 'package:inedithos_chat/Widgets/Const.dart';

class FirebaseHelper {
  //connexion
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<FirebaseUser> handleSignIn(String email, String password) async {

    AuthResult result = await auth.signInWithEmailAndPassword(email: email, password: password);
    final FirebaseUser user = result.user;
    /*assert(user != null);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await auth.currentUser();
    assert(user.uid == currentUser.uid);*/

    print('signInEmail succeeded: $user.validated');
    return user;

  }

  Future<FirebaseUser> handleSignUp(String email, String password, String name, String surname, String role) async {

    AuthResult result = await auth.createUserWithEmailAndPassword(email: email, password: password);
    final FirebaseUser user = result.user;

    /*assert (user != null);
    assert (await user.getIdToken() != null);*/

    String uid = user.uid;
    Map<String, String> map = {
      "uid": uid,
      "name": name,
      "surname": surname,
      "role": role,
      "room": defaultRoom,
    };
    addUser(uid, map);
    return user;

  }

  Future<bool> handleLogOut() async {

      await auth.signOut();
      return true;
  }

 Future<String> currentId() async{
   FirebaseUser user  = await auth.currentUser();
    return user.uid;
 }
//Database
  static final base = FirebaseDatabase.instance.reference();
  final base_user = base.child("users");
  final base_message = base.child("messages");
  final base_conversation = base.child("conversations");

  addUser (String uid, Map map){
    base_user.child(uid).set(map);
  }

  Future<User> getUser(String id) async {
    DataSnapshot snapshot = await base_user.child(id).once();
    return new User(snapshot);
  }



  sendMessage(User user, User me, String text,   String imageUrl,String fileUrl){
    String date = new DateTime.now().millisecondsSinceEpoch.toString();
  Map map = {
    "from": me.id,
    "to": user.id,
    "text": text,
    "imageUrl": imageUrl,
    "fileUrl": fileUrl,
    "dateString": date
  };
  base_message.child(getMessageRef(me.id, user.id)).child(date).set(map);
  base_conversation.child(me.id).child(user.id).set(getConversation(me.id, user, text, date));
  base_conversation.child(user.id).child(me.id).set(getConversation(me.id, me, text, date));
  }

  Map getConversation(String sender, User user, String text, String dateString){
   Map map = user.toMap();
   map["myId"]= sender;
   map["last_message"] = text;
   map["dateString"]  = dateString;
   return map;
  }

  String getMessageRef(String from, String to){
    String result= "";
    List<String> lista = [from, to];
    lista.sort((a,b) => a.compareTo(b));
    for (var x in lista){
      result += x+"+";
    }
    return result;
  }

//Storage
 static final base_storage = FirebaseStorage.instance.ref();
  final StorageReference storage_users = base_storage.child("users");
  final StorageReference storage_message = base_storage.child("messages");


  Future<String> saveFile ( File file, StorageReference ref) async {
    StorageUploadTask storageUploadTask = ref.putFile(file);
    StorageTaskSnapshot snapshot = await storageUploadTask.onComplete;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

}