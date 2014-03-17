part of useful;

class FrozenMap<K, V> implements Map<K, V> {
  Map<K, V> _data;
  num _hash;
  bool _unsorted;

  int get hashCode => _hash;
  int get length => _data.length;

  Iterable<K> get keys => _data.keys;
  Iterable<V> get values => _data.values;
  V operator [](Object key) => _data[key];

  bool containsKey(Object key) => _data.containsKey(key);
  bool containsValue(Object value) => _data.containsValue(value);

  bool get isEmpty => _data.isEmpty;
  bool get isNotEmpty => _data.isNotEmpty;

  FrozenMap([unsorted=true]) {
    _data = new Map();
    _unsorted = unsorted;
    _computeHash();
  }

  FrozenMap.from(Map<K, V> other, [unsorted=true]) {
    _data = new Map.from(other);
    _unsorted = unsorted;
    _computeHash();
  }

  void _computeHash() {
    _hash = 0;
    _data.forEach((key, value) {
      num keyValueHash = key.hashCode / value.hashCode;

      // needs to be fixed
      if (!_unsorted) {
        _hash /= keyValueHash;
      } else {
        _hash += keyValueHash;
      }
    });

    _hash %= 2<<31;
  }

  bool operator ==(FrozenMap<K, V> other) {
    if (!(other is FrozenMap)) {
      return false;
    }

    if (other.hashCode != hashCode) {
      return false;
    }

    if (other.length != length) {
      return false;
    }

    for (var key in other.keys) {
      if (other[key] != _data[key]) {
        return false;
      }
    }

    return true;
  }
}
