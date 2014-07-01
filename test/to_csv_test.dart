library useful.test.csv;

import 'package:unittest/unittest.dart';
import 'package:useful/csv.dart';

main() {
  run();
}

run() {
  group('CSV converts ', () {
    var listedData;
    var mappedData;
    var expectedResult;

    setUp(() {
      listedData =  [['name', 'age', 'color'],
                     ['John', 2, 'blue'],
                     ['Jessica', 20, 'bro"wn'],
                     ['Diana', '\'34\'', null]];
      mappedData = [];
      for (int i = 1; i < listedData.length; i++) {
        mappedData.add(new Map.fromIterables(listedData[0], listedData[i]));
      }
      expectedResult ='"name","age","color";'
                      '"John","2","blue";'
                      '"Jessica","20","bro""wn";'
                      '"Diana","\'34\'","null"';
    });

    test('list to CSV', () {
      expect(listToCSV(listedData, linesep: ';'), expectedResult);
    });

    test('map to CSV', () {
      var data = [{
        "name" : "juro",
        "age" : "21"
      },
      {
        "name" : "peto",
        "color" : "blue"
      },
      { "name" : "mato",
        "age" : "50"
      }];

      var expectedJoined ='"name","age";'
                          '"juro","21";'
                          '"peto","null";'
                          '"mato","50"';
      expect(mapToCSV(data, header: ["name","age"], linesep: ';'), expectedJoined);
    });

    test('should use appropriate conversion', () {
      expect(toCSV(listedData, linesep: ';'), expectedResult);
      expect(toCSV(mappedData, linesep: ';'), expectedResult);
    });

    test('get keys from maps', () {
      var maps = [
        {"a" : 1, "b" : 1, "e" : 1},
        {"b" : 1, "c" : 1, "e" : 1},
        {"e" : 1, "f" : 1, "a" : 1, "c" : 1},
        {"g" : 1}];
      expect(getKeysFromMaps(maps), unorderedEquals(["a","b","c","e","f","g"]));
    });

  });
}
