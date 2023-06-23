import 'package:flutter/material.dart';
import 'package:amazon_clone_flutter/models/user.dart';

class UserProvider extends ChangeNotifier{
  User _user = User(
      id:'',
      name:'',
      email:'',
      password: '',
      address:'',
      type: '',
      token:'',
  );

//this is a getter
  User get user=> _user;

//http post bata aayeko response we will pass here 
  void setUser(String user){
    _user = User.fromJson(user); 
    print("Inside User provider");
    print("_user: $_user");
    notifyListeners(); // rebuild
  }
}