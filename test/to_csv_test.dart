library useful.test.csv;

import 'package:unittest/unittest.dart';
import 'package:useful/csv.dart';

main() {
  test('to CSV', () {
      List<List> data = [['name', 'age', 'color'],
                         ['John', 2, 'blue'],
                         ['Jessica', 20, 'bro"wn'],
                         ['Diana', '\'34\'', null]];
      String expectedResult = '"name","age","color";'
                              '"John","2","blue";'
                              '"Jessica","20","bro""wn";'
                              '"Diana","\'34\'","null"';
      expect(toCSV(data, linesep: ';'), expectedResult);
  });
}