
library map_mixin_test;


import 'package:unittest/unittest.dart';
import 'package:useful/useful.dart';

class MyMap<K, V> extends Object with MapMixin<K,V>{
  Map data = {};
  operator[]=(k, v) => data[k] = v;
  operator[](k) => data[k];
  bool containsKey(K key) => data.containsKey(key);
  Iterable<K> get keys => data.keys;
  V remove(K key) => data.remove(key);
  void clear() => data.clear();
  MyMap();
  factory MyMap.from(Map m){
    MyMap res = new MyMap();
    res.addAll(m);
    return res;
  }
}

void main(){
  Map m;
  setUp((){
    m = new MyMap.from({'a': 1, 'b': 2, 'c':3});
  });

  test('length, empty', (){
    expect(m.isEmpty, isFalse);
    expect(m.isNotEmpty, isTrue);
    expect(m.length, equals(3));
  });

  test('values', (){
    expect(m.values, unorderedEquals([1,2,3]));
  });

  test('clear & isEmpty', (){
    expect(m.isEmpty, isFalse);
    expect(m.isNotEmpty, isTrue);
    m.clear();
    expect(m.isEmpty, isTrue);
    expect(m.isNotEmpty, isFalse);
    expect(m.length, equals(0));
  });

  test('forEach', (){
    Set f = new Set();
    m.forEach((k,v) => f.add(Tpl(k,v)));
    expect(f, unorderedEquals([Tpl('a',1), Tpl('b', 2), Tpl('c', 3)]));
  });
}

