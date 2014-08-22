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

    test('slice', () {
      Map map = {'a':1, 'b':2, 'c':3, 'x': {'a': {'b': 2}, 'c': 10}};
      expect(slice(map, ['a', 'b']), equals({'a': 1, 'b':2}));
      expect(slice(map, []), equals({}));
      expect(slice(map, ['c', 'd', 'e']), equals({'c': 3}));
      expect(() => slice(map, ['c', 'd'], throwIfAbsent: true), throws);
      expect(slice(map, ['a', ['x', 'a', 'b']]), equals({'a': 1, 'x': {'a': {'b': 2}}}));
      expect(slice(map, ['a', 'x.a.d']), equals({'a': 1}));
      expect(() => slice(map, ['a', 'x.a.d'], throwIfAbsent: true), throws);
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

    test('Contains in.', () {
      Map m = {'a': [5, 1, {'x': 'y'}, 10], 'b': {'c': 2}};

      expect(containsIn(null, []), isTrue);
      expect(containsIn(null, 'a'), isFalse);
      expect(containsIn(null, ['a']), isFalse);
      expect(containsIn([], ['a']), isFalse);
      expect(containsIn([8], '5'), isFalse);
      expect(containsIn([5, 1, 7, 10], [2]), isTrue);
      expect(containsIn([5, 1, 7, 10], [4]), isFalse);
      expect(containsIn(m, ['a', 2, 'x']), isTrue);
      expect(containsIn(m, 'a.c'), isFalse);
      expect(containsIn(m, 'b.c'), isTrue);

      expect(containsIn(m, 'b.d', nullIfAbsent: true), isTrue);
      expect(containsIn(m, 'b.d', nullIfAbsent: false), isFalse);
      expect(containsIn(m, 'b.d.e', nullIfAbsent: true), isFalse);
      expect(containsIn(m, 'b.d.e', nullIfAbsent: false), isFalse);
    });

    test('Get in.', () {
      var m = {'a': [5, 1, {'x': 'y'}, 10], 'b': {'c': 2}};

      expect(getIn(8, []), equals(8));
      expect(getIn([8], '5'), null);
      expect(getIn([], 'a'), null);
      expect(getIn({'a': [5, 1, 7, 10], 'b': {'c': 2}}, ['a', 2]), equals(7));
      expect(getIn(m, ['a', 2]), equals({'x': 'y'}));
      expect(getIn(m, ['a', 2, 'x']), equals('y'));
      expect(getIn(m, 'a.c'), equals(null));
      expect(getIn(m, 'a.2'), equals(null));
      expect(getIn(m, 'b.c'), equals(2));

      expect(getIn(m, 'b.d', orElse: () => 47), equals(47));
      expect(getIn(m, 'b.d', orElse: () => 47, nullIfAbsent: true), equals(null));
      expect(getIn(m, 'b.d', nullIfAbsent: true), equals(null));
      expect(getIn(m, 'b.d'), equals(null));
    });

    test('Change.', () {
      var m1 = {'a': 1, 'b': {'x': 2, 'y': 3}, 'c': [1, 2, {'x': 'y'}]};
      var m11 = {'a': 1, 'b': {'x': 2, 'y': 3}, 'c': [1, 2, {'x': 'y'}]};
      var m2 = {'b': {'x': 22, 'y': 3}, 'c': [1, 2, {'x': 'z'}]};
      var m3 = {'b': {'x': 2, 'y': 3}, 'c': [1, 2, {'x': 'z'}]};

      expect(change(m1, m11), equals({}));
      expect(change(m1, m2), equals({
        'a': [1, null],
        'b': {'x': [2, 22]},
        'c': [[1, 2, {'x': 'y'}], [1, 2, {'x': 'z'}]]
      }));
      expect(change({}, {}, ['a.b.c']), equals({}));
      expect(change(m1, m2, ['a']), equals({'a': [1, null]}));
      expect(change(m1, m2, ['d']), equals({}));
      expect(change(m1, m2, ['b', 'x']), equals({'b': {'x': [2, 22]}}));
      expect(change(m1, m2, ['b.x']), equals({'b': {'x': [2, 22]}}));
      expect(change(m1, m2, ['b.y']), equals({}));
    });
}
