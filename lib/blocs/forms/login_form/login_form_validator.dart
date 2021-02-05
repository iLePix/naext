import 'dart:async';

const String _kMin6Chars = r"^[A-Za-z\d@$!%*#?&_-]{7,}$";
const String _kEmailRule = r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$";
//const String _kMin8CharsOneLetterOneNumber = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$";
//const String _kMin8CharsOneLetterOneNumberOnSpecialCharacter = r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$";
//const String _kMin8CharsOneUpperLetterOneLowerLetterOnNumber = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$";
//const String _kMin8CharsOneUpperOneLowerOneNumberOneSpecial = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$";
//const String _kMin8Max10OneUpperOneLowerOneNumberOneSpecial = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,10}$";

mixin LoginFormValidator {

  var usernameValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (username, sink) {
        if(username.length > 4) {
          sink.add(username);
        } else {
          sink.addError("Enter a valid username");
        }
      }
  );

  var emailValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (email, sink) {
        final RegExp emailExp = new RegExp(_kEmailRule);

        if (!emailExp.hasMatch(email) || email.isEmpty){
          sink.addError('Enter a valid email');
        } else {
          sink.add(email);
        }
      }
  );

  var passwordValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (password, sink) {
        final RegExp passwordExp =
        new RegExp(_kMin6Chars);

        if (!passwordExp.hasMatch(password)){
          sink.addError('Enter a valid password');
        } else {
          sink.add(password);
        }
      }
  );
}