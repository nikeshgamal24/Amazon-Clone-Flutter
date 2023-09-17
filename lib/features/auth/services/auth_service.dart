import 'dart:convert';

import 'package:amazon_clone_flutter/common/widgets/bottom_bar.dart';
import 'package:amazon_clone_flutter/constants/error_handling.dart';
import 'package:amazon_clone_flutter/constants/utils.dart';
// import 'package:amazon_clone_flutter/features/auth/home/screens/home_screen.dart';
import 'package:amazon_clone_flutter/providers/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:amazon_clone_flutter/constants/global_variables.dart';
import 'package:amazon_clone_flutter/models/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService{

  //sign up for user
  void signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async{
    try {
      User user = User(
        id: '', 
        name: name, 
        email: email,
        password: password, 
        address: '', 
        type: '', 
        token: '',
        );

      //post requrest and return response so need to pass in the form of json for which we pass it my headers
      // print("working phase 1");
      // print(user.email);
      // we are sending the data 
      http.Response res =  await http.post(
        Uri.parse('$uri/api/signup'), 
        body:user.toJson(),
        headers: <String, String>{
         'Content-Type':'application/json;  charset=UTF-8',
          },
        );

        // print(res.body);
        // print("work/ing phase 2");

        // ignore: use_build_context_synchronously
        httpErrorHandle(
          response: res, 
          context: context, 
          onSuccess:()=> showSnackBar(context,"Account has been created sucessfully!"),
          );
          // print("httpErrorHandle section end");
        // showSnackBar(context, res.body);
        // //clears all the data of the form once the data is successfully updated to the database
        // print(formKey.currentState);
    } catch (e){
      showSnackBar(context,e.toString());
    }
  }


//sign in for user
  void signInUser({
    required context,
    required String email,
    required String password,
  })async{
    try {
      //post requrest and return response so need to pass in the form of json for which we pass it my headers
       print("----------Now time to http request---------");
      // we are sending the data 
      http.Response res =  await http.post(
        Uri.parse('$uri/api/signin'), 
        //send the data
        body:jsonEncode({
          'email':email,
          'password':password,
        }),
        headers: <String, String>{
         'Content-Type':'application/json; charset=UTF-8',
          },
        );
        // print("Response body in sign in section");
        // print(res.body);
        
        
        httpErrorHandle(
          response: res, 
          context: context, 
          onSuccess: () async{
            // we need to save the state/ token to our device  so that we can persist the state of our device
            //what is persisting state?
            
            //plugin
            //shared preferences--->store token in app memory
            // provider---> store the user data 
            print('setting sharepreference and provider work done');
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Provider.of<UserProvider>(context,listen: false).setUser(res.body);
            //set the data i.e. token 
            await prefs.setString('x-auth-token', jsonDecode(res.body)["token"]);
            // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
            Navigator.pushNamedAndRemoveUntil(context, BottomBar.routeName, (route) => false);
              print('setting navigator');

          },
          );  
        
        //clears all the data of the form once the data is successfully updated to the database
        // print(formKey.currentState);
    } catch (e){
      showSnackBar(context,e.toString());
    }
  }



//get user date
  void getUserData({
    required BuildContext context,
  })async{
    try {

      //first we want to have the sharedPreferences 
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("--------------prefs------------ that was saved");
      print('toekn $prefs');
      String? token = prefs.getString('x-auth-token'); 
      // it there is no 'x-auth-token' it wll return null and if present it will give us the data 
      print("--------------token------------ that was saved");
      print(token);

      if(token == null){
        prefs.setString('x-auth-token', '');
      }

      print("--------------token TESTING 2ND TIME------------ that was saved");
      print("token: $token");

      //checking if token is valid or not
      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers:<String,String>{
         'Content-Type':'application/json; charset=UTF-8',
         'x-auth-token':token!,  // token that we get from the shared prefereces
        },
        );

        // print("token response after http post apit hit");
        var response = jsonDecode(tokenRes.body);  //will provide true or false
        print("tokenRes: $response");

        if(response == true ){
          //get the user data  for that we need another api
          http.Response userRes =  await http.get(
            Uri.parse('$uri/'),
            headers:<String,String>{
                'Content-Type':'application/json; charset=UTF-8',
                'x-auth-token':token,  // token that we get from the shared prefereces
              },
          );

          print("Inside getUserData function");
          print(userRes.body);
          var userProvider = Provider.of<UserProvider>(context,listen: false);
          userProvider.setUser(userRes.body);
        }
    } catch (e){
      showSnackBar(context,e.toString());
    }
  }
}
