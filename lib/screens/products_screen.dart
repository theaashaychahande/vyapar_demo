import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        backgroundColor: Colors.green[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddProductDialog(context),
          ),
        ],
      ),
      body: productProvider.products.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No Products Added',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Tap the + button to add your first product',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                final product = productProvider.products[index];
                return _buildProductCard(product, context);
              },
            ),
    );
  }

  Widget _buildProductCard(Product product, BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              product.sequenceNumber.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: ₹${product.sellingPrice}'),
            Text('Stock: ${product.currentStock}'),
            if (product.isLowStock)
              Text(
                'Low Stock!',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditProductDialog(context, product),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(context, product),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ProductDialog(),
    );
  }

  void _showEditProductDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => ProductDialog(product: product),
    );
  }

  void _showDeleteDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ProductProvider>(context, listen: false)
                  .deleteProduct(product.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class ProductDialog extends StatefulWidget {
  final Product? product;

  const ProductDialog({this.product});

  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _lowStockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _sellingPriceController.text = widget.product!.sellingPrice.toString();
      _costPriceController.text = widget.product!.costPrice.toString();
      _stockController.text = widget.product!.currentStock.toString();
      _lowStockController.text = widget.product!.lowStockAlert.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final isEditing = widget.product != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Product' : 'Add New Product'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sellingPriceController,
                decoration:
                    const InputDecoration(labelText: 'Selling Price (₹)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter selling price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _costPriceController,
                decoration: const InputDecoration(labelText: 'Cost Price (₹)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cost price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Current Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter stock quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lowStockController,
                decoration: const InputDecoration(
                  labelText: 'Low Stock Alert',
                  hintText: 'Default: 5',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _saveProduct(context, productProvider, isEditing),
          child: Text(isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }

  void _saveProduct(
      BuildContext context, ProductProvider productProvider, bool isEditing) {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: isEditing
            ? widget.product!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        sequenceNumber: isEditing
            ? widget.product!.sequenceNumber
            : productProvider.nextSequenceNumber,
        sellingPrice: double.parse(_sellingPriceController.text),
        costPrice: double.parse(_costPriceController.text),
        currentStock: int.parse(_stockController.text),
        lowStockAlert: int.tryParse(_lowStockController.text) ?? 5,
        createdAt: isEditing ? widget.product!.createdAt : DateTime.now(),
      );

      if (isEditing) {
        productProvider.updateProduct(product.id, product);
      } else {
        productProvider.addProduct(product);
      }
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sellingPriceController.dispose();
    _costPriceController.dispose();
    _stockController.dispose();
    _lowStockController.dispose();
    super.dispose();
  }
}
