import 'package:flutter/material.dart';
import 'package:flutter_shop_app/helper/custom_route.dart';
import 'package:flutter_shop_app/providers/auth.dart';
import 'package:flutter_shop_app/screens/orders_screen.dart';
import 'package:flutter_shop_app/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Container(
          //   margin: const EdgeInsets.symmetric(vertical: 20),
          //   padding: const EdgeInsets.all(10),
          //   width: double.infinity,
          //   color: Theme.of(context).primaryColor,
          //   child: Text(
          //     "Shop App",
          //     style: TextStyle(
          //         fontSize: 30,
          //         fontWeight: FontWeight.bold,
          //         fontFamily: "Lato"),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          AppBar(
            automaticallyImplyLeading: false,
            title: Text("Shop App"),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Products"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersScreen.route);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Products"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProductsScreen.route);
              // Navigator.of(context).pushReplacement(
              //     CustomRoute(builder: (ctx) => UserProductsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Log Out"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/");
              Provider.of<Auth>(context, listen: false).logOut();
            },
          ),
        ],
      ),
    );
  }
}
