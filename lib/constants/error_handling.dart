import 'dart:convert';

import 'package:amazon_clone_flutter/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess, // Function()? 
}){
  // based on the statusCode we will determine if we are having error part or warning 
  switch(response.statusCode){
    case 200:
      break;
    case 400:
      showSnackBar(context, jsonDecode(response.body)['message']); //we need to decode into json to use later on
      break;
    case 500:
      showSnackBar(context, jsonDecode(response.body)["error"]);
      break;
    default:
      showSnackBar(context, response.body);

  }
}