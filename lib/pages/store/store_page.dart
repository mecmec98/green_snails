import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/store_provider.dart';
import 'create_store_item_page.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() {
    final userId = context.read<AuthProvider>().user?.id;
    if (userId != null) {
      context.read<StoreProvider>().loadItems(userId, refresh: true);
    }
  }

  Future<void> _navigateToCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateStoreItemPage()),
    );
    if (result == true) {
      _loadItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = context.watch<StoreProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Store'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreate,
        child: const Icon(Icons.add),
      ),
      body: storeProvider.loading && storeProvider.items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : storeProvider.items.isEmpty
              ? const Center(child: Text('No items in your store'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: storeProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = storeProvider.items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(Icons.storefront),
                        title: Text(item.name),
                        trailing: Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
