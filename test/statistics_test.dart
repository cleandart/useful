library useful.test.statistics;

import 'dart:math';
import 'package:unittest/unittest.dart';
import 'package:useful/useful.dart';

main() {
  test('Mean', () {
    expect(mean([1, 2, 3]), equals(2));
    expect(mean([1]), equals(1));
    expect(mean([-1, 10, 5, 20]), equals(8.5));
  });

  test('Standard deviation', () {
    expect(stdev([1, 1, 1, 1, 1]), equals(0));
    expect(stdev([-1, 1]), equals(1));
    expect(stdev([1, 2, 3]), equals(sqrt(2/3)));
  });
}
