part of useful;

mapEq(Map m1, Map m2){
  if (m1 == null && m2 == null) return true;
  if (m1 == null || m2 == null) return false;
  return m1.keys.length == m2.keys.length && m1.keys.every((k) => m1[k]==m2[k]);
}

clone(data) {
  if(data is List) {
    return new List.from(data.map((e) => clone(e)));
  }
  if(data is Map) {
    return new Map.fromIterables(data.keys, data.values.map((e) => clone(e)));
  }
  if(data is Set) {
    return new Set.from(data.map((e) => clone(e)));
  }
  return data;
}

Map mergeMaps(Map map1, Map map2) {
  Iterable keys = concat([map1.keys, map2.keys]).toSet();
  return new Map.fromIterable(keys, key: (key) => key, value: (key) {
    var val1 = map1[key];
    var val2 = map2[key];
    if (val1 is Map && val2 is Map) return mergeMaps(val1, val2);
    if (const eq.DeepCollectionEquality().equals(val1, val2)) return val1;
    if (val1 == null) return val2;
    if (val2 == null) return val1;
    throw 'Impossible to merge maps!\n'
          'Map1: $map1\nMap2: $map2\n'
          'Maps differ in value of $key.';
  });
}

containsIn(dynamic struct, dynamic keyPath) =>
    _containsIn(struct, _prepare(keyPath));

/**
 * [struct] has to support operator [], [keyPath] is either key in [struct] or
 * list of keys joined by '.' or [List] of keys describing path in [struct] (the
 * latter two can be used for deeper structures). Key joining by '.' works only
 * for string keys ('names.2' will be translated to ['names', '2']).
 *
 * Example:
 * getField({'a': [5, 1, 7, 10], 'b': {'c': 2}}, ['a', 2]) results in 7
 * getField({'a': [5, 1, 7, 10], 'b': {'c': 2}}, 'b.c') results in 2
 */
getIn(dynamic struct, dynamic keyPath, {orElse(): _getNull}) =>
  _getIn(struct, _prepare(keyPath), orElse);

bool _containsIn(dynamic struct, Iterable keyPath) {
  if (keyPath.isEmpty) return true;
  if (struct == null) return false;

  var key = keyPath.first;
  if (struct is List) {
    try {
      return _containsIn(struct[key], keyPath.skip(1));
    } catch (e) {
      return false;
    }
  }
  if (struct is Map) {
    if (!struct.containsKey(keyPath.first)) return false;
    return _containsIn(struct[key], keyPath.skip(1));
  }

  throw new ArgumentError('struct $struct is neither Map nor List');
}

dynamic _getIn(dynamic struct, Iterable keyPath, orElse()) =>
  (!_containsIn(struct, keyPath))?
      orElse() : keyPath.fold(struct, (prevMap, key) => prevMap[key]);

_getNull() => null;

List _prepare(keyPath) {
  if (keyPath is List) return keyPath;
  if (keyPath is String) return keyPath.split('.');
  throw new ArgumentError('Keypath has to be either List or String.');
}

/**
 * Creates a new Map out of the given [map] preserving only keys
 * specified in [keys]
 * [map] is the Map to be sliced
 * [keys] is a list of keys to be preserved
 */
Map slice(Map original, List keyPaths) {
  Map result = {};
  List<List> _keyPaths = keyPaths.map(_prepare).toList();
  if (_keyPaths.any((p) => p.isEmpty)) return original;

  _keyPaths.forEach((path) {
    if (_containsIn(original, path)) {
      _addPath(original, result, path);
    }
  });

  return result;
}

Map _addPath(Map original, Map result, List path) {
  var key = path.first;
  if (path.length == 1) {
    result[key] = original[key];
    return result;
  } else {
    assert(original[key] is Map);
    if (result[key] == null) result[key] = {};
    return _addPath(original[key], result[key], path.sublist(1));
  }
}

equalsDeeply(e1, e2) => new eq.DeepCollectionEquality().equals(e1, e2);

Map change(Map m1, Map m2, [List keyPaths = const [const []]]) {
  Map s1 = slice(m1, keyPaths);
  Map s2 = slice(m2, keyPaths);
  return _change(s1, s2);
}

_change(dynamic m1, dynamic m2) {
  if (m1 is! Map || m2 is! Map) return [m1, m2];

  var allKeys = m1.keys.toSet().union(m2.keys.toSet());
  var result = {};
  for (var k in allKeys) {
    if (!equalsDeeply(m1[k], m2[k])) result[k] = _change(m1[k], m2[k]);
  }
  return result;
}
