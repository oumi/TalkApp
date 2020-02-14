import 'package:firebase_database/firebase_database.dart';

class User {
  String id;
  String name;
  String surname;
  String imageUrl;
  String initiales;

  User(DataSnapshot snapshot){
    Map map = snapshot.value;
    name = map["name"];
    id = map["uid"];
    surname = map["surname"];
    imageUrl = map["imageUrl"];
    if (name!= null  && name.length >0){
      initiales = name[0];
    }
    if (surname!= null && surname.length>0)
      {
      if (initiales != null){
        initiales += surname[0];
      }else{
        initiales = surname[0];
      }
      }
  }

  Map toMap(){
    return{
      "surname":surname,
      "name": name,
      "imageUrl": imageUrl,
      "uid":id
    };
  }
}
