import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products_list.dart';
import 'package:flutter_shop_app/screens/user_products_add_edit_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({Key? key,required this.id, required this.title, required this.imageUrl})
      : super(key: key);
  final String id;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddEditUserProductScreen.route,arguments: id);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () {
                Provider.of<ProductsList>(context,listen: false).deleteProduct(id);
              },
              icon: Icon(Icons.delete_forever),
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
