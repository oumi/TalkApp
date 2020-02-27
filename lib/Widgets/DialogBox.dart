import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DialogBox {

  Future<void> information(BuildContext context, String title,
      String description) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext buildContext) {
          return (Theme
              .of(context)
              .platform == TargetPlatform.iOS)
              ? new CupertinoAlertDialog(title: Text(title),
            content: Text(description),
            actions: <Widget>[acceptButton(buildContext)],)
              : new AlertDialog (
            title: Text(title),
            content: Text(description),
            actions: <Widget>[acceptButton(buildContext)],);
        }
    );
  }

  FlatButton acceptButton(BuildContext context) {
    return new FlatButton(
      // onPressed: ()=>Navigator.of(context).pop(),
        onPressed: () => Navigator.pop(context),
        child: new Text("Acceptar"));
  }

}
