import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/order.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatefulWidget {
  const OrderItemWidget({Key? key, required this.order, required this.index})
      : super(key: key);
  final Order order;
  final int index;

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      child: Column(children: [
        ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: FittedBox(
                  child: Text(
                widget.index.toString(),
                style: TextStyle(color: Colors.white),
              )),
            ),
          ),
          title: Text("\$${widget.order.amount.toStringAsFixed(2)}"),
          subtitle: Text(
              DateFormat("dd/MMMM/yy hh:mm").format(widget.order.orderTime)),
          trailing: IconButton(
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            icon: _expanded
                ? const Icon(Icons.expand_less)
                : const Icon(Icons.expand_more),
          ),
        ),
        if (_expanded)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
            height: min(widget.order.products.length * 20.0 + 10, 180),
            child: ListView(
              children: widget.order.products
                  .map((e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${e.quantity} X"),
                          Text(e.title),
                          Text("\$${e.price.toStringAsFixed(2)}"),
                        ],
                      ))
                  .toList(),
            ),
          )
      ]),
    );
  }
}
