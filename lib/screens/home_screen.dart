import 'package:flutter/material.dart';
import 'products_screen.dart';
import 'sales_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Vyapar'),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.store, size: 50, color: Colors.green),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to Vyapar!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Manage your shop easily',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildActionCard(
                    'Manage Products',
                    Icons.inventory,
                    Colors.blue,
                    () {
                      _navigateToProducts(context);
                    },
                  ),
                  _buildActionCard(
                    'New Sale',
                    Icons.shopping_cart,
                    Colors.green,
                    () {
                      _navigateToSales(context);
                    },
                  ),
                  _buildActionCard(
                    'View Stock',
                    Icons.warehouse,
                    Colors.orange,
                    () {
                      _showComingSoon(context, 'Stock View');
                    },
                  ),
                  _buildActionCard(
                    'Reports',
                    Icons.analytics,
                    Colors.purple,
                    () {
                      _showComingSoon(context, 'Reports');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 35, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToSales(BuildContext context) {
    print('Navigating to Sales Screen...');
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => const SalesScreen(),
      ),
    )
        .then((_) {
      print('Returned from Sales Screen');
    });
  }

  void _navigateToProducts(BuildContext context) {
    print('Navigating to Products Screen...');
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => ProductsScreen(),
      ),
    )
        .then((_) {
      print('Returned from Products Screen');
    });
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
