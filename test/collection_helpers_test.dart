library clone_test;

import 'package:unittest/unittest.dart';
import 'package:useful/useful.dart';

main() {
  group('Clone', () {
    test('Map', () {
      Map map = {'6+4': 210, '9+2': 711, '8+5': 313};
      var copy = clone(map);
      expect(copy, equals(map));
      expect(copy.hashCode, isNot(equals(map.hashCode)));
    });

    test('Set', () {
          Set set = new Set.from([1, 1, 2, 3, 5, 8, 13, 21, 34]);
          var copy = clone(set);
          expect(copy, equals(set));
          expect(copy.hashCode, isNot(equals(set.hashCode)));
    });

    test('List', () {
          List list = [1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796];
          var copy = clone(list);
          expect(copy, equals(list));
          expect(copy.hashCode, isNot(equals(list.hashCode)));
    });
  });

  group('Deepcopy', () {
      test('Map', () {
        Map map = {1: ['one', 'jedna', 'eins'], 2: ['two', 'tri', 'drei']};
        var copy = clone(map);
        expect(copy, equals(map));
        expect(copy.hashCode, isNot(equals(map.hashCode)));
        expect(copy[1].hashCode, isNot(equals(map[1].hashCode)));
      });

      test('Set', () {
            Set set = new Set.from([{'one': 1}, ['one', 'one', 'two']]);
            var copy = clone(set);
            expect(copy, equals(set));
            expect(copy.hashCode, isNot(equals(set.hashCode)));
            expect(copy.first, equals(set.first));
            expect(copy.first.hashCode, isNot(equals(set.first.hashCode)));
            expect(copy.last, equals(set.last));
            expect(copy.last.hashCode, isNot(equals(set.last.hashCode)));
      });

      test('List', () {
            List list = [new Set.from([1,2]), {'car': 'auto'}];
            var copy = clone(list);
            expect(copy, equals(list));
            expect(copy.hashCode, isNot(equals(list.hashCode)));
            expect(copy[0].hashCode, isNot(equals(list[0].hashCode)));
            expect(copy[1].hashCode, isNot(equals(list[1].hashCode)));
      });
    });

    test('slice', (){
      Map map = {'a':1, 'b':2, 'c':3};
      expect(slice(map, ['a', 'b']), equals({'a': 1, 'b':2}));
      expect(slice(map, []), equals({}));
      expect(slice(map, ['c', 'd', 'e']), equals({'c': 3}));
    });

    group('Merge maps', () {
      test('merges maps correctly when possible.', () {
        Duration hour = new Duration(hours: 1);
        Map m1, m2, merged;

        m1 = {'a': 1, 'b': 2};
        m2 = {'b': 2, 'c': 3};
        merged = {'a': 1, 'b': 2, 'c': 3};
        expect(mergeMaps(m1, m2), equals(merged));

        m1 = {'a': 1, 'b': {'bb': 1, 'dd': 100}, 'list': [1, 2, 3],
              'time': hour};
        m2 = {'b': {'cc': 2, 'dd': 100}, 'd': 10, 'list': [1, 2, 3],
              'time': hour};
        merged = {'a': 1, 'b': {'bb': 1, 'cc': 2, 'dd': 100},
                  'list': [1, 2, 3], 'd': 10, 'time': hour};
        expect(mergeMaps(m1, m2), equals(merged));
      });

      test('throws when unable to merge.', () {
        Map m1, m2;

        m1 = {'a': 1};
        m2 = {'a': '1'};
        expect(() => mergeMaps(m1, m2), throws);

        m1 = {'a': {'b': 1}};
        m2 = {'a': {'b': '1'}};
        expect(() => mergeMaps(m1, m2), throws);

        m1 = {'a': new Duration(hours: 1)};
        m2 = {'a': new Duration(hours: 2)};
        expect(() => mergeMaps(m1, m2), throws);
      });

    });
}
