import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/store_provider.dart';
import '../../models/store_item.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    final storeProvider = context.read<StoreProvider>();
    Future.microtask(() {
      final userId = authProvider.user?.id;
      if (userId != null && storeProvider.hasStore) {
        storeProvider.loadItems(userId, refresh: true);
      }
    });
  }

  void _showAddEditDialog({StoreItem? item}) {
    final nameController = TextEditingController(text: item?.name ?? '');
    final descController = TextEditingController(text: item?.description ?? '');
    final priceController = TextEditingController(
      text: item != null ? item.price.toStringAsFixed(2) : '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item != null ? 'Edit Item' : 'Add Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              final price = double.tryParse(priceController.text.trim());
              if (name.isEmpty || price == null) return;

              final data = {
                'name': name,
                'description': descController.text.trim(),
                'price': price,
              };

              final provider = context.read<StoreProvider>();
              if (item != null) {
                provider.updateItem(item.id, data);
              } else {
                final userId = context.read<AuthProvider>().user?.id;
                if (userId != null) {
                  provider.createItem({...data, 'user_id': userId});
                }
              }
              Navigator.pop(ctx);
            },
            child: Text(item != null ? 'Save' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(StoreItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<StoreProvider>().deleteItem(item.id);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _createStore() async {
    final userId = context.read<AuthProvider>().user?.id;
    if (userId == null) return;

    final success = await context.read<StoreProvider>().createStore(userId);
    if (success && mounted) {
      context.read<StoreProvider>().loadItems(userId, refresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = context.watch<StoreProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Store'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: storeProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : !storeProvider.hasStore
              ? _buildNoStore(context)
              : storeProvider.items.isEmpty
                  ? _buildEmptyStore(context)
                  : _buildStoreGrid(context),
      floatingActionButton: storeProvider.hasStore
          ? FloatingActionButton.extended(
              onPressed: () => _showAddEditDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            )
          : null,
    );
  }

  Widget _buildNoStore(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer,
              ),
              child: Icon(
                Icons.storefront_outlined,
                size: 56,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'You don\'t have a store yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Create your store to start selling products to the community.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _createStore,
              icon: const Icon(Icons.add_business),
              label: const Text('Create Your Store'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStore(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        final userId = context.read<AuthProvider>().user?.id;
        if (userId != null) {
          await context.read<StoreProvider>().loadItems(userId, refresh: true);
        }
      },
      child: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your store is empty',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the button below to add your first product',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreGrid(BuildContext context) {
    final storeProvider = context.watch<StoreProvider>();

    return RefreshIndicator(
      onRefresh: () async {
        final userId = context.read<AuthProvider>().user?.id;
        if (userId != null) {
          await storeProvider.loadItems(userId, refresh: true);
        }
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: storeProvider.items.length,
        itemBuilder: (context, index) {
          final item = storeProvider.items[index];
          return _StoreItemCard(
            item: item,
            onEdit: () => _showAddEditDialog(item: item),
            onDelete: () => _confirmDelete(item),
          );
        },
      ),
    );
  }
}

class _StoreItemCard extends StatelessWidget {
  final StoreItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _StoreItemCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: onEdit,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer,
                      colorScheme.tertiaryContainer,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.storefront,
                    size: 48,
                    color: colorScheme.onPrimaryContainer.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const Spacer(),
                        PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          iconSize: 20,
                          onSelected: (value) {
                            if (value == 'edit') onEdit();
                            if (value == 'delete') onDelete();
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: ListTile(
                                leading: Icon(Icons.edit_outlined),
                                title: Text('Edit'),
                                contentPadding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: ListTile(
                                leading: Icon(Icons.delete_outline, color: Colors.red),
                                title: Text('Delete', style: TextStyle(color: Colors.red)),
                                contentPadding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
