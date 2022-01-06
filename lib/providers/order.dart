import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:http/http.dart';

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime orderTime;

  Order(this.id, this.amount, this.products, this.orderTime);
}

class Orders with ChangeNotifier {
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._items);

  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  Future<void> addOrder(double amount, List<CartItem> products) async {
    final url = Uri.parse(
        "https://flutter-shop-7a9c6-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken");
    try {
      final response = await post(url,
          body: json.encode({
            "amount": amount,
            "products": products
                .map((e) => {
                      "id": e.id,
                      "title": e.title,
                      "price": e.price,
                      "quantity": e.quantity,
                    })
                .toList(),
            "orderTime": DateTime.now().toIso8601String(),
          }));
      final id = json.decode(response.body);
      _items.insert(0, Order(id["name"], amount, products, DateTime.now()));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getOrders() async {
    final url = Uri.parse(
        "https://flutter-shop-7a9c6-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken");
    try {
      final response = await get(url);
      if (json.decode(response.body) == null) {
        return;
      }
      final orders = json.decode(response.body) as Map<String, dynamic>;
      List<Order> orderList = [];
      orders.forEach((id, value) {
        orderList.add(Order(
            id,
            value["amount"],
            (value["products"] as List<dynamic>)
                .map((e) => CartItem(
                    id: e["id"],
                    title: e["title"],
                    price: e["price"],
                    quantity: e["quantity"]))
                .toList(),
            DateTime.parse(value["orderTime"])));
      });
      _items = orderList.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
