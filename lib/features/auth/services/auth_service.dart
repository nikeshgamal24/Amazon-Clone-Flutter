import 'package:amazon_clone_flutter/constants/error_handling.dart';
import 'package:amazon_clone_flutter/constants/utils.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:amazon_clone_flutter/constants/global_variables.dart';
import 'package:amazon_clone_flutter/models/user.dart';


class AuthService{

  //sign up for user
  void signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required GlobalKey<FormState> formKey,
  })async{
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

      // we are sending the data 
      http.Response res =  await http.post(
        Uri.parse('$uri/api/signup'), 
        body:user.toJson(),
        headers: <String, String>{
         'Content-Type':'application/json',
          },
        );

        // print(res.body);
        
        // ignore: use_build_context_synchronously
        httpErrorHandle(
          response: res, 
          context: context, 
          onSuccess: (){
            showSnackBar(context, 'Account created! Login with the same credentials');
           },
          );  
        
        //clears all the data of the form once the data is successfully updated to the database
        // print(formKey.currentState);
    } catch (e){
      showSnackBar(context,e.toString());
    }
  }
}