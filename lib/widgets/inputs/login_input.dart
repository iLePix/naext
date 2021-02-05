import 'package:flutter/material.dart';
import 'package:youreco/utils/colors.dart';


class LoginInput extends StatefulWidget {
  final stream;
  final onChanged;
  final labelText;
  final controller;
  final inputFormatters;
  final isPassword;
  final keyBoardType;

  const LoginInput({Key key, this.stream, this.onChanged, this.labelText, this.controller, this.inputFormatters, this.isPassword, this.keyBoardType}) : super(key: key);

  _LoginInput createState() => _LoginInput();
}

class _LoginInput extends State<LoginInput> {


  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.stream,
        builder: (context, snapshot) {
          return TextField(
              keyboardType: widget.keyBoardType,
              onChanged: widget.onChanged,
              obscureText: widget.isPassword,//_obscureText,
              inputFormatters: widget.inputFormatters != null ? widget.inputFormatters : [],
              controller: widget.controller != null ? widget.controller : null,
              style: TextStyle(
                color: Colors.black
              ),
              decoration: InputDecoration(
                //suffixIcon: hidePasswordSuffix(),//widget.isPassword ? hidePasswordSuffix() : null,
                labelText: widget.labelText,
                errorText: snapshot.error,
                labelStyle: TextStyle(color: FOREGROUND_COLOR),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 3.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 3.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                    BorderSide(width: 3.0, color: FOREGROUND_COLOR)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    color: DARKBACKGROUND_COLOR,
                    width: 1.0,
                  ),
                ),
              ));
        }
    );
  }

  /*Widget hidePasswordSuffix() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
      child: Icon(
        _obscureText
            ? Icons.visibility
            : Icons.visibility_off,
        semanticLabel:
        _obscureText ? 'show password' : 'hide password',
        color: Colors.white,
      ),
    );
  }*/

}