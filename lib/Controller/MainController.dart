import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inedithos_chat/Model/FirebaseHelper.dart';
import 'package:inedithos_chat/Controller/MessagesController.dart';
import 'package:inedithos_chat/Controller/ProfileController.dart';
import 'package:inedithos_chat/Controller/ContactsController.dart';

class MainController extends StatefulWidget{
  MainState createState() => new MainState();
}


class MainState extends State<MainController>{
  String id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseHelper().currentId().then((uid){
      setState(() {
        id = uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Text title = new Text("Inedithos Chat");
    return new FutureBuilder(
      future: FirebaseHelper().auth.currentUser(),
        builder:(BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
          if (snapshot.connectionState == ConnectionState.done){
              if (Theme.of(context).platform == TargetPlatform.iOS){
                  return new CupertinoTabScaffold(
                      tabBar: new CupertinoTabBar(
                          backgroundColor: Colors.indigo,
                          activeColor: Colors.black,
                          inactiveColor: Colors.white,
                          items: [
                        new BottomNavigationBarItem(icon: new Icon(Icons.message),),
                        new BottomNavigationBarItem(icon: new Icon(Icons.supervisor_account),),
                        new BottomNavigationBarItem(icon: new Icon(Icons.account_circle),),
                      ]),

                       tabBuilder: (BuildContext context, int index){
                        Widget controllerSelected = controllers()[index];
                        return new Scaffold(
                          appBar: new AppBar(title:title,),
                          body: controllerSelected,
                        );
                       }
                  );
              }else{
                return new DefaultTabController(
                  length: 3,
                  child: new Scaffold(
                    appBar: new AppBar(
                      title: title,
                      bottom: new TabBar(tabs: [
                        new Tab(icon: new Icon(Icons.message),),
                        new Tab(icon: new Icon(Icons.supervisor_account),),
                        new Tab(icon: new Icon(Icons.account_circle),),
                      ])
                    ),
                    body: new TabBarView(
                        children: controllers()),
                  )
                );
              }
          }else {
            //Cargando
            return new Scaffold(
              appBar: new AppBar(title: title),
              body: new Center(
                child: new Text(
                "Cargando ...",
                  style: new TextStyle(
                    fontSize: 30.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.indigoAccent
                  ),
              ),
            ),
          );
          }
        }
    );


  }

  List<Widget> controllers(){
    return [
      new MessagesController(id),
      new ProfileController(id),
      new ContactsController(id)
    ];
  }

}
