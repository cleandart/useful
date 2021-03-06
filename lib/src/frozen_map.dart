part of useful;

class FrozenMap<K, V> {
  Map<K, V> _data;
  num _hash;
  bool _ordered;

  int get hashCode => _hash;
  int get length => _data.length;

  Iterable<K> get keys => _data.keys;
  Iterable<V> get values => _data.values;
  V operator [](Object key) => _data[key];

  bool containsKey(Object key) => _data.containsKey(key);
  bool containsValue(Object value) => _data.containsValue(value);

  bool get isEmpty => _data.isEmpty;
  bool get isNotEmpty => _data.isNotEmpty;

  void forEach(void f(K key, V value)) => _data.forEach(f);

  FrozenMap([ordered=true]) {
    _data = new Map();
    _ordered = ordered;
    _computeHash();
  }

  FrozenMap.from(Map<K, V> other, [ordered=true]) {
    _data = new Map.from(other);
    _ordered = ordered;
    _computeHash();
  }

  void _computeHash() {
    _hash = 0;
    var res;

    if (!_ordered) {
      _data.forEach((key, value) {
        var p = 16381;
        res = (key.hashCode % p) * (value.hashCode % p) ;

        _hash += res;
        _hash %= 1<<32;
      });
    } else {
      _hash = 17;
      _data.forEach((key, value) {
        _hash = _hash*31 + key.hashCode;
        _hash %= 2<<31;

        _hash = _hash*31 + value.hashCode;
        _hash %= 2<<31;

      });

    }
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
