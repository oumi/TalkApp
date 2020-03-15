import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:inedithos_chat/Widgets/Const.dart';
/*
* Draw the loading spinkit
 */
class Loading extends StatelessWidget {
@override
  Widget build(BuildContext context) {
    return Container (
     // color: teal400,
      child: Center (
        child: SpinKitDualRing(
            color: teal400,
            size: 50.0
        ),
      ),
    );
  }
}