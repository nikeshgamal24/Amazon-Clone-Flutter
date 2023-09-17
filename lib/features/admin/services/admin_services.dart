import 'dart:io';

import 'package:amazon_clone_flutter/constants/error_handling.dart';
import 'package:amazon_clone_flutter/constants/global_variables.dart';
import 'package:amazon_clone_flutter/constants/utils.dart';
import 'package:amazon_clone_flutter/models/product.dart';
import 'package:amazon_clone_flutter/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
class AdminServices{
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async{
    final  userProvider = Provider.of<UserProvider>(context,listen: false);
    try {
       print("inside admin services cloudinary section");
      //job is to store the images 
      final cloudinary = CloudinaryPublic("dxc7qbvdk", 'yde7nlfp');

      //Work:: list of string images url --> map through all the images and send to cloudinary storage
      List<String> imageUrls=[];
      
      print("inside admin services cloudinary section to store images");
      for(int i=0;i<images.length;i++){
        //cloudinary upload
        //  print('inside loop before async');
       CloudinaryResponse res =  await cloudinary.uploadFile(CloudinaryFile.fromFile(images[i].path,folder:name));
    // print('inside loop after async');
       imageUrls.add(res.secureUrl);
      }

      print("inside admin services uploading product detail to mongodb section");
      // work:: will be uploading the urls only to the mongodb
      Product product = Product(
        name: name, 
        description: description, 
        quantity: quantity, 
        images: imageUrls, 
        category: category, 
        price: price,
        );


        print("inside admin services before api hit");
        //create the api //post request
        print("request body:");
        print(product.toJson());
        print(userProvider.user);
        http.Response res = await http.post(
          Uri.parse('$uri/admin/add-product'),
          headers:<String,String> {
            'Content-Type':'application/json; charset=UTF-8',
            'x-auth-token':userProvider.user.token,
          },
          body:product.toJson(),
          );

          print("Https response");
          print("Response:  $res");
          // ignore: use_build_context_synchronously
          httpErrorHandle(response: res, context: context, onSuccess: (){
            showSnackBar(context, 'Product Added successfully');
            Navigator.pop(context);
          });

           print("End Https Error handle");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}