import '../models/store_item.dart';
import 'api_client.dart';

class StoreService {
  final ApiClient _api = ApiClient();

  int _parseTotal(dynamic total) {
    if (total == null) return 0;
    if (total is int) return total;
    if (total is String) return int.tryParse(total) ?? 0;
    return 0;
  }

  List<StoreItem> _parseItemList(dynamic data) {
    if (data == null || data is! List) return [];
    return (data as List).map((i) => StoreItem.fromJson(i as Map<String, dynamic>)).toList();
  }

  Future<({List<StoreItem> items, int total})> getItems(String userId, {int page = 1, int limit = 20}) async {
    final response = await _api.get('/store/$userId', queryParams: {
      'page': page.toString(),
      'limit': limit.toString(),
    });
    final items = _parseItemList(response['items']);
    return (items: items, total: _parseTotal(response['total']));
  }

  Future<StoreItem> createItem(Map<String, dynamic> data) async {
    final response = await _api.post('/store', body: data);
    return StoreItem.fromJson(response['item'] as Map<String, dynamic>);
  }

  Future<StoreItem> updateItem(String id, Map<String, dynamic> data) async {
    final response = await _api.put('/store/$id', body: data);
    return StoreItem.fromJson(response['item'] as Map<String, dynamic>);
  }

  Future<void> deleteItem(String id) async {
    await _api.delete('/store/$id');
  }
}
