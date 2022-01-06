import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart.dart' as ci;
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  const CartItem({Key? key, required this.cartItem,required this.productId}) : super(key: key);
  final ci.CartItem cartItem;
  final String productId;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        padding: const EdgeInsets.only(right: 10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete,color: Colors.white,size: 26,),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        return showDialog(context: context, builder: (ctx) => AlertDialog(title: Text("Are you sure you want to delete?"),actions: [
          TextButton(onPressed: () {
            Navigator.of(ctx).pop(true);
          }, child: Text("yes")),
          TextButton(onPressed: () {
            Navigator.of(ctx).pop(false);
          }, child: Text("no")),
        ],));
      },
      onDismissed: (_) {
        Provider.of<ci.Cart>(context,listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(child: Text("\$${cartItem.price}")),
            ),
          ),
          title: Text(cartItem.title),
          subtitle: Text("Total: \$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}"),
          trailing: Text("${cartItem.quantity} X"),
        ),
      ),
    );
  }
}
