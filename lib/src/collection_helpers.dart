part of useful;

mapEq(Map m1, Map m2){
  if (m1 == null && m2 == null) return true;
  if (m1 == null || m2 == null) return false;
  return m1.keys.length == m2.keys.length && m1.keys.every((k) => m1[k]==m2[k]);
}


/**
 * Creates a new Map out of the given [map] preserving only keys
 * specified in [keys]
 * [map] is the Map to be sliced
 * [keys] is a list of keys to be preserved
 */
Map slice(Map map, List keys) {
  Map result = {};

  keys.forEach((key) {
    if (map.containsKey(key)) {
      result[key] = map[key];
    }
  });

  return result;
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
