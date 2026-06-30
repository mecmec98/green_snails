import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/market_provider.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MarketProvider>().loadItems(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final marketProvider = context.watch<MarketProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: marketProvider.loading && marketProvider.items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : marketProvider.items.isEmpty
              ? const Center(child: Text('No items in market'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: marketProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = marketProvider.items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(Icons.shopping_basket),
                        title: Text(item.name),
                        subtitle: Text(item.sellerName ?? 'Unknown'),
                        trailing: Text(
                          '\$${item.price.toStringAsFixed(2)} / ${item.unit}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
