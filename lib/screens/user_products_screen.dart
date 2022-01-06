import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products_list.dart';
import 'package:flutter_shop_app/screens/user_products_add_edit_screen.dart';
import 'package:flutter_shop_app/widgets/main_drawer.dart';
import 'package:flutter_shop_app/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);
  static const route = "/user-products-screen";

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<ProductsList>(context, listen: false)
        .getProductsFromServer(true);
  }

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<ProductsList>(context).products;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text("your products"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddEditUserProductScreen.route);
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Loading Products"),
                      ],
                    ),
                  )
                : Consumer<ProductsList>(
                    builder: (ctx, products, _) => RefreshIndicator(
                      onRefresh: () => _refresh(context),
                      child: ListView.builder(
                        itemBuilder: (_, index) {
                          return Column(
                            children: [
                              UserProductItem(
                                  id: products.products[index].id,
                                  title: products.products[index].title,
                                  imageUrl: products.products[index].imageUrl),
                              Divider(),
                            ],
                          );
                        },
                        itemCount: products.products.length,
                      ),
                    ),
                  ),
      ),
    );
  }
}
