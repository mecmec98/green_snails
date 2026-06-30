import 'package:flutter/material.dart';
import '../models/store_item.dart';
import '../services/store_service.dart';

class StoreProvider extends ChangeNotifier {
  final StoreService _storeService = StoreService();

  List<StoreItem> _items = [];
  bool _loading = false;
  String? _error;
  int _total = 0;
  int _page = 1;
  bool _hasMore = true;

  List<StoreItem> get items => _items;
  bool get loading => _loading;
  String? get error => _error;
  bool get hasMore => _hasMore;

  Future<void> loadItems(String userId, {bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _hasMore = true;
    }

    if (!_hasMore && !refresh) return;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _storeService.getItems(userId, page: _page);

      if (refresh) {
        _items = result.items;
      } else {
        _items.addAll(result.items);
      }

      _total = result.total;
      _hasMore = _items.length < _total;
      _page++;
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<StoreItem?> createItem(Map<String, dynamic> data) async {
    try {
      final item = await _storeService.createItem(data);
      _items.insert(0, item);
      notifyListeners();
      return item;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<StoreItem?> updateItem(String id, Map<String, dynamic> data) async {
    try {
      final item = await _storeService.updateItem(id, data);
      final index = _items.indexWhere((i) => i.id == id);
      if (index != -1) _items[index] = item;
      notifyListeners();
      return item;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteItem(String id) async {
    try {
      await _storeService.deleteItem(id);
      _items.removeWhere((i) => i.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
