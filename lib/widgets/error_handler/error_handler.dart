
import 'package:flutter/material.dart';
import 'package:naext/services//colors.dart';



class ErrorHandler<T> extends StatelessWidget {

  final Object errorObject;

  ErrorHandler(this.errorObject);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.keyboard_arrow_down, size: 40, color: FOREGROUND_COLOR,),
            Text("Swipe down to reload", style: TextStyle(fontSize: 20, color: FOREGROUND_COLOR,fontWeight: FontWeight.w800)),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(errorObject.toString(), style: TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center,),
            )
          ],
        ),
      ),
    );
  }
}