import 'dart:convert';
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

class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      print("inside admin services cloudinary section");
      //job is to store the images
      final cloudinary = CloudinaryPublic("dxc7qbvdk", 'yde7nlfp');

      //Work:: list of string images url --> map through all the images and send to cloudinary storage
      List<String> imageUrls = [];

      print("inside admin services cloudinary section to store images");
      for (int i = 0; i < images.length; i++) {
        //cloudinary upload
        //  print('inside loop before async');
        CloudinaryResponse res = await cloudinary
            .uploadFile(CloudinaryFile.fromFile(images[i].path, folder: name));
        // print('inside loop after async');
        imageUrls.add(res.secureUrl);
      }

      print(
          "inside admin services uploading product detail to mongodb section");
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
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );

      print("Https response");
      print("Response:  $res");
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Product Added successfully');
            Navigator.pop(context);
          });

      print("End Https Error handle");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

//fetch all the products
//return list of products by converting
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    //we need user Provide to have the token
    final userProvider = Provider.of<UserProvider>(context,listen: false);
    List<Product> productList = [];
    try {
      print("===========================================");
      print("Beginning fetchAllProducts");
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-products'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      print("===========================================");
      print("End fetchAllProducts");
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i <jsonDecode(res.body).length; i++) {
              productList.add(
                // have to convert into model
                Product.fromJson(
                  jsonEncode(
                    jsonDecode(res.body)[i],
                  ),
                ),
              );
              
              // print(jsonEncode(jsonDecode(res.body)[i]));
              // print(json.decode(jsonEncode(jsonDecode(res.body)[i])));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
    //THe reason behind using the VoidCallback is that since we need to delete the product formt he client side and the server side so 

    // IN the stateful widget we apply the changes using the setState() but since this is a stateLess Widget to achieve the functionality we use VoidCallback onSuccess
    }) async{
       final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      print("inside delete product");
      
      http.Response res = await http.post(
        Uri.parse('$uri/admin/delete-product'),
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({//if doesnot work then send it by jsonEncode({"id":product.id})
          "id":product.id,
        }),
      );

      print("Https response");
      print("Response:  $res");
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            onSuccess();
          });

      print("End Https Error handle");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    }
}
