import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:coffee_app/models/product.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'coffee-app-8e3af-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;

  bool isLoading = true;
  bool isSaving = false;

  // TODO: Hacer el fetch de los productos

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'productos.json');
    final response = await http.get(url);
    final Map<String, dynamic> extractedData = json.decode(response.body);

    extractedData.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();
    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();
    if (product.id == null) {
      // Es necesrio crear un nuevo producto
      await createProduct(product);
    } else {
      // Es necesario actualizar un producto
      await updateProduct(product);
    }
    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'productos/${product.id}.json');
    final response = await http.put(url, body: product.toJson());
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'productos.json');
    final response = await http.post(url, body: product.toJson());
    final decodeData = json.decode(response.body);
    product.id = decodeData['name'];
    products.add(product);
    return product.id!;
  }
}
