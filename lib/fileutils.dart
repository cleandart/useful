library useful.fileutils;

import 'dart:io';

/**
 * Writes data to file provided. [file] can be either [File] or [String], in
 * latter case, it is expected to be path to the file. If [recursive] is false,
 * the default, the file is created only if all directories in the path exist.
 *  If [recursive] is true, all non-existing path components are created.
 */
writeAsString(dynamic file, String data, {recursive: false}) {
  File _f;
  if (file is File) _f = file;
  else if (file is String) _f = new File(file);
  else throw new ArgumentError('Type of file can only be String or File!');
  return _f.create(recursive: true).then((_) => _f.writeAsString(data));
}
