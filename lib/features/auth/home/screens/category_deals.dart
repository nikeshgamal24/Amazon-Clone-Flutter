import 'package:amazon_clone_flutter/common/widgets/loader.dart';
import 'package:amazon_clone_flutter/features/auth/home/services/home_services.dart';
import 'package:amazon_clone_flutter/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone_flutter/models/product.dart';
import 'package:flutter/material.dart';

import '../../../../constants/global_variables.dart';

class CategoryDealsScreen extends StatefulWidget {
  static const String routeName = '/category-deals';
  final String category;
  const CategoryDealsScreen({super.key, required this.category});

  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  List<Product>? productList;
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
  }

  fetchCategoryProducts() async {
    productList = await homeServices.fetchCategoryProducts(
        context: context, category: widget.category);

    // again need to re build the builder so need to have setState funciton
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          //reason to use the flexiblespace is that we want to have the linear Gradient to the AppBar but AppBar doesnot have the property lineargradiend so we use flexibleSpace
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Text(
            widget.category,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: productList == null
          ? const Loader()
          : Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Keep shoping for ${widget.category}',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 170,
                  // if we dont know the height of the item count then it is very handy to use these listView builder and gridView builder
                  child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 15),
                      itemCount: productList!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 1.4,
                              mainAxisSpacing: 10),
                      itemBuilder: (
                        context,
                        index,
                      ) {
                        final product = productList![index];
                        //return the p
                        return GestureDetector(
                          onTap: ()=> Navigator.pushNamed(context, ProductDetailScreen.routeName,arguments:product),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 130,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: Colors.black12,
                                    width: 0.5,
                                  )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.network(product.images[0]),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topCenter,
                                padding: const EdgeInsets.only(
                                    left: 0, top: 5, right: 15),
                                    child: Text(
                                      product.name,
                                      maxLines: 1,
                                      overflow:TextOverflow.ellipsis,
                                    ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
    );
  }
}
