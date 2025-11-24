import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/sale.dart';

class SaleProvider with ChangeNotifier {
  List<Sale> _sales = [];

  List<Sale> get sales => _sales;

  Future<void> addSale(List<SaleItem> items) async {
    final total = items.fold(0.0, (sum, item) => sum + item.total);
    final sale = Sale(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: items,
      totalAmount: total,
      timestamp: DateTime.now(),
    );

    _sales.add(sale);
    await _saveSales();
    notifyListeners();
  }

  Future<void> _saveSales() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final salesJson = _sales.map((s) => s.toMap()).toList();
      await prefs.setString('sales', json.encode(salesJson));
    } catch (e) {
      print('Error saving sales: $e');
    }
  }

  Future<void> loadSales() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final salesJson = prefs.getString('sales');
      if (salesJson != null) {
        final List<dynamic> salesList = json.decode(salesJson);
        _sales = salesList.map((s) => Sale.fromMap(s)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading sales: $e');
    }
  }
}
