library useful.csv;

String toCSV(List data, {List header: null, String sep: ',',
  String linesep: '\n'}) {
  if (data.every((e) => e is List)) {
    return listToCSV(data, header: header, sep: sep, linesep: linesep);
  } else if (data.every((e) => e is Map)) {
    return mapToCSV(data, header: header, sep: sep, linesep: linesep);
  } else {
    throw new UnsupportedError('Type of data provided is not supported');
  }
}

String listToCSV(List<List> data, {List header: null, String sep: ',',
  String linesep: '\n'}) {
  prepare(field) {
    String result = '$field'.replaceAll('"', '""');
    return '"$result"';
  }

  List<List> newData = [];
  if (header != null) newData.add(header);
  data.forEach((List line) => newData.add(line.map(prepare).toList()));

  return newData.map((line) => line.join(sep)).join(linesep);
}

String mapToCSV(List<Map> data, {List header: null, String sep: ',',
  String linesep: '\n'}) {
  var keys = header == null ? getKeysFromMaps(data) : header;
  List<List> newData =
      data.map((Map m) => keys.map((k) => m[k]).toList()).toList();

  return listToCSV(newData, header: keys, sep: sep, linesep: linesep);
}

List getKeysFromMaps(List<Map> data) {
  Set keys = new Set();
  data.forEach((m) {
    keys = keys.union(new Set.from(m.keys));
  });
  return keys.toList();
}
