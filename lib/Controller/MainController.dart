import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inedithos_chat/Model/FirebaseHelper.dart';
import 'package:inedithos_chat/Controller/MessagesController.dart';
import 'package:inedithos_chat/Controller/ProfileController.dart';
import 'package:inedithos_chat/Controller/ContactsController.dart';
import 'package:inedithos_chat/Widgets/Choice.dart';
import 'package:inedithos_chat/Widgets/Const.dart';
import 'package:inedithos_chat/Widgets/Loading.dart';
import 'package:inedithos_chat/lang/cas.dart';

/*
* Draw the shape of the basical main screen that contains tha navigationBarItems
* and the drop down menu
 */
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
    Text title = new Text(
      appName,
      style: TextStyle(color: blueGrey, fontWeight: FontWeight.bold),
    );
    return new FutureBuilder(
        future: FirebaseHelper().auth.currentUser(),
        builder:(BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
          //Once we are connected
          if (snapshot.connectionState == ConnectionState.done){
            //Draw the tabbar
            //TODO: ios part: this part has to finiched to be the same as android part
            if (Theme.of(context).platform == TargetPlatform.iOS){
              return new CupertinoTabScaffold(
                  tabBar: new CupertinoTabBar(
                      backgroundColor: Colors.white,
                      activeColor: Colors.black,
                      inactiveColor: Colors.white,
                      items: [
                        new BottomNavigationBarItem(icon: new Icon(Icons.message)),
                        new BottomNavigationBarItem(icon: new Icon(Icons.supervisor_account)),
                        new BottomNavigationBarItem(icon: new Icon(Icons.account_circle)),
                      ]),

                  tabBuilder: (BuildContext context, int index){
                    Widget controllerSelected = controllers()[index];
                    return new Scaffold(
                      appBar: new AppBar(title: title,),
                      body: controllerSelected,
                    );
                  }
              );
            }else{
              //Android part
              return new DefaultTabController(
                  length: 3,
                  child: new Scaffold(
                    appBar: new AppBar(
                      title: title,
                      centerTitle: true,
                      bottom: new TabBar(
                          tabs: [
                        new Tab(icon: new Icon(Icons.message, color:cyan, size: 30.0)),
                        new Tab(icon: new Icon(Icons.supervisor_account,color:cyan, size: 30.0)),
                        new Tab(icon: new Icon(Icons.account_circle, color:cyan,size: 30.0),),
                      ],
                          indicatorColor: teal400),
                    //Menu part
                      actions: <Widget>[
                        PopupMenuButton<Choice>(
                          onSelected: onItemMenuPress,
                          itemBuilder: (BuildContext context) {
                            return choices.map((Choice choice) {
                              return PopupMenuItem<Choice>(
                                  value: choice,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        choice.icon,
                                        color: blueGrey,
                                      ),
                                      Container(
                                        width: 10.0,
                                      ),
                                      Text(
                                        choice.title,
                                        style: TextStyle(color: blueGrey),
                                      ),
                                    ],
                                  ));
                            }).toList();
                          },
                        ),
                      ],
                    ),
                    // call the controllers of every tab to manage the content
                    body: new TabBarView(
                        children: controllers()),
                  )
              );
            }
          }else {
            //loading page
            return new Scaffold(
              appBar: new AppBar(title: title),
              body: Loading()
            );
          }
        }
    );


  }
//List of choices of the menu
  bool isLoading = false;
  String cerrar = 'Cerrar sesión';
  List<Choice> choices = const <Choice>[
    const Choice(title: cas_text_signOut, icon: Icons.exit_to_app),
  ];

  void onItemMenuPress(Choice choice) {
    if (choice.title == cerrar) {
      logOut(context);
    }
  }

  Future<void> logOut(BuildContext context) async{
    Text title = new Text(cerrar);
    Text subtitle = new Text(cas_text_sureToSignOut);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext build){
          return (Theme.of(context).platform == TargetPlatform.iOS )
              ? new CupertinoAlertDialog(title: title, content: subtitle, actions: _actions(build),)
              : new AlertDialog(title: title, content: subtitle, actions: _actions(build));
        }
    );
  }

  List<Widget> _actions (BuildContext build){
    List<Widget> widgets = [];
    widgets.add(new FlatButton(
        onPressed:(){
          FirebaseHelper().handleLogOut().then((bool){
            Navigator.of(build).pop();
          });
        },
        child: new Text(cas_text_yes,
          style: new TextStyle(
              fontStyle: FontStyle.italic,
              color: teal400
          ),))
    );
    widgets.add(new FlatButton(
        onPressed: ()=> Navigator.of(build).pop(),
        child: new Text(cas_text_no,
          style: new TextStyle(
              fontStyle: FontStyle.italic,
              color: teal400
          ),))
    );
    return widgets;
  }


  List<Widget> controllers(){
    return [
      new MessagesController(id),
      new ProfileController(id),
      new ContactsController(id)
    ];
  }

}
