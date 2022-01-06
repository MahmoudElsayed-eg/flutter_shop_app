import 'package:flutter/material.dart';
import 'package:flutter_shop_app/helper/custom_route.dart';
import 'package:flutter_shop_app/providers/auth.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/providers/order.dart';
import 'package:flutter_shop_app/providers/products_list.dart';
import 'package:flutter_shop_app/screens/auth_screen.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/screens/orders_screen.dart';
import 'package:flutter_shop_app/screens/products_details_screen.dart';
import 'package:flutter_shop_app/screens/products_overview_screen.dart';
import 'package:flutter_shop_app/screens/user_products_add_edit_screen.dart';
import 'package:flutter_shop_app/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsList>(
          create: (ctx) => ProductsList("", "", []),
          update: (BuildContext context, value, ProductsList? previous) {
            return ProductsList(
                value.token != null ? value.token! : "",
                value.userId != null ? value.userId! : "",
                previous != null ? previous.products : []);
          },
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders("", "", []),
          update: (context, value, previous) {
            return Orders(
                value.token != null ? value.token! : "",
                value.userId != null ? value.userId! : "",
                previous != null ? previous.items : []);
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Shop App',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: "Lato",
            pageTransitionsTheme: CustomPageTransition(),
          ),
          home: !auth.isAuth
              ? FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? Scaffold(
                              body: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Loading ..."),
                                  ],
                                ),
                              ),
                            )
                          : AuthScreen(),
                )
              : ProductsOverViewScreen(),
          routes: {
            ProductDetailsScreen.route: (_) => ProductDetailsScreen(),
            CartScreen.route: (_) => CartScreen(),
            OrdersScreen.route: (_) => OrdersScreen(),
            UserProductsScreen.route: (_) => UserProductsScreen(),
            AddEditUserProductScreen.route: (_) => AddEditUserProductScreen(),
          },
        ),
      ),
    );
  }
}
