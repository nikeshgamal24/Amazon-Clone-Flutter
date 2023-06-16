import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget{
  // this routeName will be used to navigate to one page to another in the switch case in the router.dart file which will have all the routes and control the routes between the pages of the application
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState(){
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: ElevatedButton(
        onPressed: (){
          Navigator.pop(context);
        }, 
        child: const Text('Go Back')
        ),
    );
  }
}