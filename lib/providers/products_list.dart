import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/auth.dart';
import 'package:flutter_shop_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class ProductsList with ChangeNotifier {
  final String authToken;
  final String userId;

  ProductsList(this.authToken, this.userId, this._products);

  List<Product> _products = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favProducts {
    return _products.where((element) => element.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        "https://flutter-shop-7a9c6-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken");
    try {
      final value = await http.post(url,
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "userId": userId,
          }));
      final editedProduct = Product(
          id: json.decode(value.body)["name"],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _products.add(editedProduct);
      print(editedProduct.id);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getProductsFromServer([bool filterByUser = false]) async {
    try {
      final filteredString =
          filterByUser ? 'orderBy="userId"&equalTo="$userId"' : "";
      final url = Uri.parse(
          'https://flutter-shop-7a9c6-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken&$filteredString');
      final response = await http.get(url);
      if (json.decode(response.body) == null) {
        return;
      }
      final favUrl = Uri.parse(
          "https://flutter-shop-7a9c6-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken");
      final favResponse = await http.get(favUrl);
      final favData = json.decode(favResponse.body);
      final map = json.decode(response.body) as Map<String, dynamic>;
      List<Product> list = [];
      map.forEach((id, value) {
        list.add(Product(
          id: id,
          title: value["title"],
          description: value["description"],
          imageUrl: value["imageUrl"],
          price: value["price"],
          isFavorite: favData == null ? false : favData["$id"] ?? false,
        ));
      });
      _products = list;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void deleteProduct(String id) {
    Product? product = _products.firstWhere((element) => element.id == id);
    final url = Uri.parse(
        "https://flutter-shop-7a9c6-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken");
    _products.removeWhere((element) => element.id == id);
    http.delete(url).then((value) => product = null).catchError((_) {
      _products.add(product!);
      notifyListeners();
    });
    notifyListeners();
  }

  Product getProductById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(Product product) async {
    final url = Uri.parse(
        "https://flutter-shop-7a9c6-default-rtdb.europe-west1.firebasedatabase.app/products/${product.id}.json?auth=$authToken");
    await http.patch(url,
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
        }));
    final int index =
        _products.indexWhere((element) => element.id == product.id);
    _products[index] = product;
    notifyListeners();
  }
}
