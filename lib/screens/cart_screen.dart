import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/providers/order.dart';
import 'package:flutter_shop_app/widgets/cart_item.dart' as ci;
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const String route = "/cart-screen";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;

  Future<void> _addCart(Cart cart,double totalPrice, List<CartItem> cartList) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Orders>(context, listen: false)
          .addOrder(totalPrice, cartList);
      cart.clear();
    } catch (error) {

      await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Error"),
            content: Text("something went wrong"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Okay"))
            ],
          ));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final totalPrice = cart.itemsTotalPrice;
    final cartList = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("your Cart"),
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$${cart.itemsTotalPrice.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    onPressed: (_isLoading || cartList.length == 0)? null :() {
                      _addCart(cart,totalPrice, cartList);
                    },
                    child: _isLoading ? CircularProgressIndicator() : Text("ORDER NOW"),
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor)),
                  )
                ],
              ),
            ),
            elevation: 5,
            margin: const EdgeInsets.all(15),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => ci.CartItem(
                cartItem: cartList[index],
                productId: cart.items.keys.toList()[index],
              ),
              itemCount: cartList.length,
            ),
          ),
        ],
      ),
    );
  }
}
