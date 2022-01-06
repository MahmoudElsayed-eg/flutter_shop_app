import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/providers/products_list.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/widgets/badge.dart';
import 'package:flutter_shop_app/widgets/main_drawer.dart';
import 'package:flutter_shop_app/widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum Filter { Favorite, All }

class ProductsOverViewScreen extends StatefulWidget {
  ProductsOverViewScreen({Key? key}) : super(key: key);
  static const route = "/products-screen";

  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  bool _isFavorite = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if(_isInit) {
      _isLoading = true;
      Provider.of<ProductsList>(context,listen: false).getProductsFromServer().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = !_isInit;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text("Shop App"),
        actions: [
          PopupMenuButton(
              onSelected: (Filter filter) {
                setState(() {
                  if (filter == Filter.Favorite) {
                    _isFavorite = true;
                  } else {
                    _isFavorite = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text("show favorites"),
                      value: Filter.Favorite,
                    ),
                    PopupMenuItem(
                      child: Text("show all"),
                      value: Filter.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(child: ch!, value: cart.itemsCount.toString()),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.route);
              },
            ),
          ),
        ],
      ),
      body: _isLoading ? Center(child: Column(mainAxisSize: MainAxisSize.min,children: [
        CircularProgressIndicator(),
        SizedBox(height: 10,),
        Text("Loading Products"),
      ],),) : ProductsGrid(
        isFav: _isFavorite,
      ),
    );
  }
}
