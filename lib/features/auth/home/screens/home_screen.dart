import 'package:amazon_clone_flutter/constants/utils.dart';
import 'package:amazon_clone_flutter/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone_flutter/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget build(BuildContext context) {
  @override
  final user = Provider.of<UserProvider>(context).user;

    return  Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text("Welcome to Home Screen",
              style: TextStyle(
                fontSize: 24,
              ),),
            ),
            ElevatedButton(
              onPressed: () async{
                try{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString("x-auth-token", '');
                  Navigator.pushNamedAndRemoveUntil(context, AuthScreen.routeName, (route) => false);
                }catch(err){
                  showSnackBar(context, err.toString());
                }
              }, 
              child:const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                ),
                ),
              )
          ],
        ),      
    );
  }
}