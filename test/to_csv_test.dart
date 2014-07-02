library useful.test.csv;

import 'package:unittest/unittest.dart';
import 'package:useful/csv.dart';

main() {
  run();
}

run() {
  group('Convert to CSV format', () {
    var header = ['name', 'age', 'color'];
    var data =  [['John', 2, 'blue'],
                 ['Jessica', 20, 'bro"wn'],
                 ['Diana', '\'34\'', null]];

    test('for list of lists with header.', () {
      var expected ='name,age,color;'
                    '"John","2","blue";'
                    '"Jessica","20","bro""wn";'
                    '"Diana","\'34\'","null"';
      expect(listToCSV(data, header: header, linesep: ';'), expected);
    });

    test('for list of lists without header.', () {
      var expected ='"John","2","blue";'
                    '"Jessica","20","bro""wn";'
                    '"Diana","\'34\'","null"';
      expect(listToCSV(data, linesep: ';'), expected);
    });
  });

  test('Convert to CSV format for list of maps.', () {
    var data = [{"name" : "juro", "age" : "21"},
                {"name" : "peto", "color" : "blue"},
                {"name" : "mato", "age" : "50"}];

    var expectedJoined ='name,age;'
                        '"juro","21";'
                        '"peto","null";'
                        '"mato","50"';
    expect(mapToCSV(data, header: ["name","age"], linesep: ';'), expectedJoined);
  });

  test('Convert to CSV format uses appropriate conversion.', () {
    var header = ['a', 'b', 'c'];
    var listedData = [[1, 2, 3], [4, 5, 6]];
    var mappedData = [{'a': 1, 'b': 2, 'c': 3}, {'a': 4, 'b': 5, 'c': 6}];
    var expected = 'a,b,c;"1","2","3";"4","5","6"';

    expect(toCSV(listedData, header: header, linesep: ';'), expected);
    expect(toCSV(mappedData, header: header, linesep: ';'), expected);
    expect(toCSV(mappedData, linesep: ';'), expected);
  });

  test('Get keys from maps.', () {
    var maps = [
      {"a" : 1, "b" : 1, "e" : 1},
      {"b" : 1, "c" : 1, "e" : 1},
      {"e" : 1, "f" : 1, "a" : 1, "c" : 1},
      {"g" : 1}];
    expect(getKeysFromMaps(maps), unorderedEquals(["a","b","c","e","f","g"]));
  });
}
