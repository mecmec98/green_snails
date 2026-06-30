import '../models/market_item.dart';
import 'api_client.dart';

class MarketService {
  final ApiClient _api = ApiClient();

  int _parseTotal(dynamic total) {
    if (total == null) return 0;
    if (total is int) return total;
    if (total is String) return int.tryParse(total) ?? 0;
    return 0;
  }

  List<MarketItem> _parseItemList(dynamic data) {
    if (data == null || data is! List) return [];
    return (data as List).map((i) => MarketItem.fromJson(i as Map<String, dynamic>)).toList();
  }

  Future<({List<MarketItem> items, int total})> getItems({int page = 1, int limit = 20, String? search}) async {
    final params = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search != null) params['search'] = search;

    final response = await _api.get('/market', queryParams: params);
    final items = _parseItemList(response['items']);
    return (items: items, total: _parseTotal(response['total']));
  }

  Future<MarketItem> getItem(String id) async {
    final response = await _api.get('/market/$id');
    return MarketItem.fromJson(response['item'] as Map<String, dynamic>);
  }

  Future<MarketItem> createItem(Map<String, dynamic> data) async {
    final response = await _api.post('/market', body: data);
    return MarketItem.fromJson(response['item'] as Map<String, dynamic>);
  }

  Future<MarketItem> updateItem(String id, Map<String, dynamic> data) async {
    final response = await _api.put('/market/$id', body: data);
    return MarketItem.fromJson(response['item'] as Map<String, dynamic>);
  }

  Future<void> deleteItem(String id) async {
    await _api.delete('/market/$id');
  }
}
