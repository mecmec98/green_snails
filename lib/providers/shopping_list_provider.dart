import 'package:flutter/material.dart';

class ShoppingItem {
  final String name;
  final DateTime date;
  bool checked;

  ShoppingItem({required this.name, required this.date, this.checked = false});
}

class ShoppingListProvider extends ChangeNotifier {
  final List<ShoppingItem> _items = [];

  List<ShoppingItem> get items => List.unmodifiable(_items);

  void addItem(String name, DateTime date) {
    _items.add(ShoppingItem(name: name, date: date));
    notifyListeners();
  }

  void addItems(List<String> names, DateTime date) {
    for (final name in names) {
      _items.add(ShoppingItem(name: name, date: date));
    }
    notifyListeners();
  }

  void toggleItem(int index) {
    _items[index].checked = !_items[index].checked;
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}
