import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products_list.dart';
import 'package:flutter_shop_app/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({Key? key, required this.isFav}) : super(key: key);
  final bool isFav;

  @override
  Widget build(BuildContext context) {
    final providedData = Provider.of<ProductsList>(context);
    final products = isFav ? providedData.favProducts : providedData.products;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3 / 2),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
          // title: products[i].title,
          // id: products[i].id,
          // imageUrl: products[i].imageUrl,
        ),
      ),
      itemCount: products.length,
    );
  }
}
