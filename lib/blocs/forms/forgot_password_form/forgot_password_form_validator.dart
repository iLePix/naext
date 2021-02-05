import 'dart:async';

mixin ForgotPasswordFormValidator {

  var emailValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (email, sink) {
        if(email.contains("@") && email.contains(".")) {
          sink.add(email);
        } else {
          sink.addError("This is not an Email");
        }
      }
  );

  var tokenValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (token, sink) {
        if(token.length == 6) {
          sink.add(token);
        } else {
          sink.addError("Invalid token length");
        }
      }
  );

  var passwordValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (password, sink) {
        if(password.length > 5) {
          sink.add(password);
        } else {
          sink.addError("Email zu kurz");
        }
      }
  );
}