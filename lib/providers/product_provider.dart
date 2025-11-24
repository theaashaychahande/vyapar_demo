import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => List.unmodifiable(_products);
  List<Product> get lowStockProducts =>
      _products.where((p) => p.isLowStock).toList();

  // Get next available sequence number
  int get nextSequenceNumber {
    if (_products.isEmpty) return 1;
    return _products
            .map((p) => p.sequenceNumber)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }

  // Add new product
  Future<void> addProduct(Product product) async {
    _products.add(product);
    await _saveProducts();
    notifyListeners();
  }

  // Update product
  Future<void> updateProduct(String id, Product updatedProduct) async {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      _products[index] = updatedProduct;
      await _saveProducts();
      notifyListeners();
    }
  }

  // Delete product
  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
    await _saveProducts();
    notifyListeners();
  }

  // Get product by sequence number
  Product? getProductBySequence(int sequenceNumber) {
    try {
      return _products.firstWhere((p) => p.sequenceNumber == sequenceNumber);
    } catch (e) {
      return null;
    }
  }

  // Update stock after sale
  Future<void> updateStock(int sequenceNumber, int quantitySold) async {
    final product = getProductBySequence(sequenceNumber);
    if (product != null) {
      final updatedProduct = Product(
        id: product.id,
        name: product.name,
        sequenceNumber: product.sequenceNumber,
        sellingPrice: product.sellingPrice,
        costPrice: product.costPrice,
        currentStock: product.currentStock - quantitySold,
        lowStockAlert: product.lowStockAlert,
        expiryDate: product.expiryDate,
        createdAt: product.createdAt,
      );
      await updateProduct(product.id, updatedProduct);
    }
  }

  // Save products to local storage
  Future<void> _saveProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson = _products.map((p) => p.toMap()).toList();
      await prefs.setString('products', json.encode(productsJson));
    } catch (e) {
      print('Error saving products: $e');
    }
  }

  // Load products from local storage
  Future<void> loadProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson = prefs.getString('products');
      if (productsJson != null) {
        final List<dynamic> productsList = json.decode(productsJson);
        _products = productsList.map((p) => Product.fromMap(p)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading products: $e');
    }
  }
}
