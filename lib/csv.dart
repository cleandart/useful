library useful.csv;

String toCSV(List data, {String sep: ',', String linesep: '\n'}) {
  if (data.every((e) => e is List)) {
    return listToCSV(data, sep: sep, linesep: linesep);
  } else if (data.every((e) => e is Map)) {
    return mapToCSV(data, sep: sep, linesep: linesep);
  } else {
    throw new UnsupportedError('Type of data provided is not supported');
  }
}

String listToCSV(List<List> data, {String sep: ',', String linesep: '\n'}) {
  prepare(field) {
    String result = '$field'.replaceAll('"', '""');
    return '"$result"';
  }
  return data.map((line) => line.map(prepare).join(sep)).join(linesep);
}

String mapToCSV(List<Map> data, {header: null, String sep: ',', String linesep: '\n'}) {
  var keys = header == null ? getKeysFromMaps(data) : header;
  List<List> newData = [keys];
  data.forEach((Map m) {
    newData.add(keys.map((k) => m[k]).toList());
  });
  return listToCSV(newData, sep: sep, linesep: linesep);
}

List getKeysFromMaps(List<Map> data) {
  Set keys = new Set();
  data.forEach((m) {
    print(m.keys);
    keys = keys.union(new Set.from(m.keys));
  });
  return keys.toList();
}