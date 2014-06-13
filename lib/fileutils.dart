library useful.fileutils;

import 'dart:async';
import 'dart:io';

/**
 * Writes data to file provided. [file] can be either [File] or [String], in
 * latter case it is expected to be path to the file. If [recursive] is false,
 * the default, the file is created only if all directories in the path exist.
 * If [recursive] is true, all non-existing path components are created.
 */
Future<File> writeAsString(dynamic file, String data, {recursive: false}) {
  File _f = _toFile(file);
  return _writeAsSth(_f, _f.writeAsString, data, recursive);
}

/**
 * Writes data to file provided. [file] can be either [File] or [String], in
 * latter case it is expected to be path to the file. If [recursive] is false,
 * the default, the file is created only if all directories in the path exist.
 * If [recursive] is true, all non-existing path components are created.
 */
Future<File> writeAsBytes(dynamic file, List<int> data, {recursive: false}) {
  File _f = _toFile(file);
  return _writeAsSth(_f, _f.writeAsBytes, data, recursive);
}

/**
 * Writes data to file provided. [file] can be either [File] or [String], in
 * latter case it is expected to be path to the file. If [recursive] is false,
 * the default, the file is created only if all directories in the path exist.
 * If [recursive] is true, all non-existing path components are created.
 */
writeAsStringSync(dynamic file, String data, {recursive: false}) {
  File _f = _toFile(file);
  return _writeAsSthSync(_f, _f.writeAsStringSync, data, recursive);
}

/**
 * Writes data to file provided. [file] can be either [File] or [String], in
 * latter case it is expected to be path to the file. If [recursive] is false,
 * the default, the file is created only if all directories in the path exist.
 * If [recursive] is true, all non-existing path components are created.
 */
void writeAsBytesSync(dynamic file, List<int> data, {recursive: false}) {
  File _f = _toFile(file);
  _writeAsSthSync(_f, _f.writeAsBytesSync, data, recursive);
}

_writeAsSthSync(File f, write(data), data, recursive) {
  f.createSync(recursive: recursive);
  return write(data);
}

Future<File> _writeAsSth(File f, write(data), data, recursive) =>
    f.create(recursive: recursive).then((_) => write(data));

File _toFile(dynamic file) {
  if (file is File) return file;
  else if (file is String) return new File(file);
  else throw new ArgumentError('Type of file can only be String or File!');
}
