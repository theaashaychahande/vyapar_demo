class Sale {
  String id;
  List<SaleItem> items;
  double totalAmount;
  DateTime timestamp;

  Sale({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'] ?? '',
      items:
          (map['items'] as List).map((item) => SaleItem.fromMap(item)).toList(),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}

class SaleItem {
  int sequenceNumber;
  String productName;
  double price;
  int quantity;

  SaleItem({
    required this.sequenceNumber,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  double get total => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'sequenceNumber': sequenceNumber,
      'productName': productName,
      'price': price,
      'quantity': quantity,
    };
  }

  factory SaleItem.fromMap(Map<String, dynamic> map) {
    return SaleItem(
      sequenceNumber: map['sequenceNumber'] ?? 0,
      productName: map['productName'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 0,
    );
  }
}
