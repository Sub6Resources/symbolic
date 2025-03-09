import 'dart:collection';

class DefaultMap<K, V> with MapMixin<K, V> {

  final Map<K, V> _map;
  final V Function() defaultValue;

  DefaultMap(this.defaultValue): _map = {};

  @override
  V operator [](Object? key) {
    return _map[key] ?? defaultValue();
  }

  @override
  void operator []=(K key, V value) {
    _map[key] = value;
  }

  @override
  void clear() {
    _map.clear();
  }

  @override
  Iterable<K> get keys => _map.keys;

  @override
  V? remove(Object? key) {
    return _map.remove(key);
  }

}