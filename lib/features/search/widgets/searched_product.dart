import 'package:amazon_clone_flutter/common/widgets/stars.dart';
import 'package:amazon_clone_flutter/models/product.dart';
import 'package:flutter/material.dart';

class SearchedProduct extends StatelessWidget {
  final Product product;
  const SearchedProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    double totalRating = 0;
    for (int i = 0; i < product.rating!.length; i++) {
      totalRating += product.rating![i].rating;
    }
    
    double avgRating=0;

    if (totalRating != 0) {
      avgRating = totalRating / product.rating!.length;
    }

    return Column(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Image.network(
                  product.images[0],
                  fit: BoxFit.fitHeight,
                  height: 135,
                  width: 135,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 235,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      Container(
                        width: 235,
                        padding: const EdgeInsets.only(left: 10,top:5),
                        child:  Stars(rating: avgRating),
                      ),
                      Container(
                        width: 235,
                        padding:  const EdgeInsets.only(left: 10,top:5),
                        child: Text(
                          '\$${product.price}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600
                          ),
                          maxLines: 2,
                        ),
                      ),
                       Container(
                        width: 235,
                        padding:  const EdgeInsets.only(left: 10,),
                        child: const Text(
                          'Eligible For FREE Shipping',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          maxLines: 2,
                        ),
                      ),
                       Container(
                        width: 235,
                        padding:  const EdgeInsets.only(left: 10,top:5),
                        child: const Text(
                          'In Stock',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.teal,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }
}
