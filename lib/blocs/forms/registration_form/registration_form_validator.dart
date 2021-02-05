import 'dart:async';

mixin RegistrationFormValidator {

  var usernameValidator= StreamTransformer<String,String>.fromHandlers(
      handleData: (username, sink) {
        if(username.length > 5) {
          sink.add(username);
        } else {
          sink.addError("Name zu kurz");
        }
      }
  );

  var emailValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (email, sink) {
        if(email.length > 5) {
          sink.add(email);
        } else {
          sink.addError("Email zu kurz");
        }
      }
  );

  var passwordValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (password, sink) {
        if(password.length > 6) {
          sink.add(password);
        } else {
          sink.addError("Passwort zu kurz");
        }
      }
  );
}