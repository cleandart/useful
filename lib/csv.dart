library useful.csv;

String toCSV(List<List> data, {String sep: ',', String linesep: '\n'}) {
  prepare(field) {
    String result = '$field'.replaceAll('"', '""');
    return '"$result"';
  }
  return data.map((line) => line.map(prepare).join(sep)).join(linesep);
}
