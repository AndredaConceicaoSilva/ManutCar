import 'package:flutter/material.dart';
import 'package:manutcar/user.dart';

class UserProvider extends InheritedWidget{
  final Widget child; 
  List<User> users = [];

  UserProvider(
    {
      required this.child,
    }
  ) : super(child: child);

  static UserProvider? of (BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserProvider>();
  }

  bool updateShouldNotify(UserProvider Widget){
    return true;
  }
}