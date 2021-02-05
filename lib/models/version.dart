import 'package:flutter/cupertino.dart';

class Version {
  final int patch;
  final int major;
  final int minor;

  List<Object> get props => [patch, major, minor];
  Version({@required this.patch, @required this.major, @required this.minor});

  Version.fromJson(Map<String, dynamic> json) :
        patch = json['patch'],
        major = json['major'],
        minor = json['minor'];

  Map<String, dynamic> toJson() => {
    'patch' : patch,
    'major' : major,
    'minor' : minor,
  };
}