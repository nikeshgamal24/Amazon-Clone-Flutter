
import 'dart:convert';

import 'package:amazon_clone_flutter/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../constants/error_handling.dart';
import '../../../../constants/global_variables.dart';
import '../../../../constants/utils.dart';
import '../../../../models/product.dart';
import '../../../../providers/user_provider.dart';
import 'package:http/http.dart' as http;

class ProductDetailsServices {
  //add to cart
  void addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
          
      http.Response res = await http.post(
        Uri.parse('$uri/api/add-to-cart'),
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id':product.id,
        }),
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            //now from the copyWith we fetch the only cart content from it as we have return whole user from backend
            User user = userProvider.user.copyWith(
              cart: jsonDecode(res.body)['cart']
            );
            // we need to updat the userProvider so to update we use setUpdate but  here we can't do that as it require String but here user is a model type
            userProvider.setUserFromModel(user);   
          },
        );

    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }


  //rate product
  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
          
      http.Response res = await http.post(
        Uri.parse('$uri/api/rate-product'),
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id':product.id!,
          'rating':rating,
        }),
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {},
        );

    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}