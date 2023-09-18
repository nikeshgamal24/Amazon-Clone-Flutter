import 'dart:convert';

import 'package:amazon_clone_flutter/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/error_handling.dart';
import '../../../../constants/global_variables.dart';
import '../../../../constants/utils.dart';
import '../../../../providers/user_provider.dart';

class HomeServices{
  Future<List<Product>> fetchCategoryProducts({required BuildContext context, required String category}) async{
    //we need user Provide to have the token
    final userProvider = Provider.of<UserProvider>(context,listen: false);
    List<Product> productList = [];
    try {
      print("===========================================");
      print("Beginning fetchCategoryProducts");
      http.Response res = await http.get(
        Uri.parse('$uri/api/products?category=$category'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      print("===========================================");
      print("End fetchCategoryProducts");
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
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }
}