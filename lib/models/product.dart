class Product {
  String id;
  String name;
  int sequenceNumber;
  double sellingPrice;
  double costPrice;
  int currentStock;
  int lowStockAlert;
  DateTime? expiryDate;
  DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.sequenceNumber,
    required this.sellingPrice,
    required this.costPrice,
    required this.currentStock,
    this.lowStockAlert = 5,
    this.expiryDate,
    required this.createdAt,
  });

  // Calculate profit
  double get profitPerUnit => sellingPrice - costPrice;
  double get totalProfit => profitPerUnit * currentStock;

  // Check if stock is low
  bool get isLowStock => currentStock <= lowStockAlert;

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sequenceNumber': sequenceNumber,
      'sellingPrice': sellingPrice,
      'costPrice': costPrice,
      'currentStock': currentStock,
      'lowStockAlert': lowStockAlert,
      'expiryDate': expiryDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      sequenceNumber: map['sequenceNumber'] ?? 0,
      sellingPrice: (map['sellingPrice'] ?? 0).toDouble(),
      costPrice: (map['costPrice'] ?? 0).toDouble(),
      currentStock: map['currentStock'] ?? 0,
      lowStockAlert: map['lowStockAlert'] ?? 5,
      expiryDate:
          map['expiryDate'] != null ? DateTime.parse(map['expiryDate']) : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }
}
