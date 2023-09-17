import 'package:amazon_clone_flutter/common/widgets/loader.dart';
import 'package:amazon_clone_flutter/features/account/widgets/single_product.dart';
import 'package:amazon_clone_flutter/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone_flutter/features/admin/services/admin_services.dart';
import 'package:amazon_clone_flutter/models/product.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<Product>? products;
  final AdminServices adminServices = AdminServices();

  //initstate funciton cannot be async
  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {
      
    });
  }
  
  void deleteProduct(Product product, int index){
    adminServices.deleteProduct(
      context: context, 
      product: product, 
      onSuccess: (){
        products!.removeAt(index); //remove at the particular index
        setState(() {//we need to reflect the changes on the screen so we need to re build the builder so we use this setState
        });
      },
      );
  }

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
            // fetcht the data and poulate the screen
            body: GridView.builder(
              itemCount: products!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2) , itemBuilder:((context, index) {
              final productData = products![index];

              //return a colum for images and details of the product
              return Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: SingleProduct(image: productData.images[0]),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text(
                            productData.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                         ),
                         IconButton(
                          onPressed: ()=> deleteProduct(productData, index), 
                          icon:const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  )
                ],
              );
            } ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: navigateToAddProduct,
              tooltip: "Add a Product",
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            // This will align the floatingAction button the centerof the screen
          );
  }
}
