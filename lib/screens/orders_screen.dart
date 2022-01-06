import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/order.dart';
import 'package:flutter_shop_app/widgets/main_drawer.dart';
import 'package:flutter_shop_app/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const route = "/orders-screen";

  @override
  Widget build(BuildContext context) {
    // final orders = Provider.of<Orders>(context);
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: Text("orders"),
        ),
        body: FutureBuilder(
          builder: (ctx, data) {
            if (data.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (data.error != null) {
                return Center(
                  child: Text("Error"),
                );
              } else {
                return Consumer<Orders>(
                  builder: (_, orders, child) => orders.items.length <= 0
                      ? Center(
                          child: Text("No Orders yet!"),
                        )
                      : ListView.builder(
                          itemBuilder: (ctx, index) => OrderItemWidget(
                            order: orders.items[index],
                            index: index + 1,
                          ),
                          itemCount: orders.items.length,
                        ),
                );
              }
            }
          },
          future: Provider.of<Orders>(context, listen: false).getOrders(),
        ));
  }
}


/*
to use futurebuilder in stateful use this approach :

late Future variable;
Future method() {
return someFuture;
}
initState{
variable = method();
super.initstate;
}

 */