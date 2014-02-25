part of useful;

abstract class MapMixin<K,V> implements Map<K,V> {

  operator[]=(K key, V val);
  operator[](K key);
  bool containsKey(K key);
  Iterable<K> get keys;
  V remove(K key);
  void clear();

  V putIfAbsent(K key, V ifAbsent()) {
    if (this.containsKey(key)) {
      return this[key];
    } else {
      var val = ifAbsent();
      this[key] = ifAbsent();
      return val;
    }
  }

  bool containsValue(Object value) => values.contains(value);

  int get length => keys.length;

  void addAll(Map<K, V> other){
    other.forEach((k,v){
      this[k] = v;
    });
  }

  void forEach(void f(K key, V value)){
    for(K key in this.keys){
      f(key, this[key]);
    }
  }


  Iterable<V> get values => this.keys.map((k) => this[k]);

  bool get isEmpty => !this.keys.iterator.moveNext();

  bool get isNotEmpty => !isEmpty;

}