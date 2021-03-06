library frozen_test;

import 'package:unittest/unittest.dart';
import 'package:useful/useful.dart';

void main() {
  group('FrozenSet', (){

    test('basic set props', (){
      var fs = new FrozenSet.from([1,2,2,3,3,3,4,4,4,4]);
      expect(fs.length, equals(4));
      expect(fs, unorderedEquals([1,2,3,4]));
    });

    test('equality and hashcode', (){
      var fs123 = new FrozenSet.from([1,2,3]);
      var fs321 = new FrozenSet.from([3,2,1]);
      var fs1234 = new FrozenSet.from([1,2,3,4]);
      expect(fs123 == fs321, isTrue);
      expect(fs123 == fs1234, isFalse);
      expect(fs123.hashCode == fs321.hashCode, isTrue);
      expect(fs123.hashCode == fs1234.hashCode, isFalse);
    });
  });

  group("FrozenMap", () {

    test('basic map props', () {
      var frozenMap = new FrozenMap.from({
        'key1' : 'value1',
        'key2' : 'value2',
        'key3' : 3
      });

      expect(frozenMap.length, equals(3));
      expect(frozenMap, equals(new FrozenMap.from({
        'key1' : 'value1',
        'key2' : 'value2',
        'key3' : 3
      })));
    });

    test('basic equality and hashcode', () {
      var fm1 = new FrozenMap.from({
        'key1' : 'value1',
        'key2' : 'value2',
        null : 'value3'
      }, false);

      var fm2 = new FrozenMap.from({
        'key2' : 'value2',
        null : 'value3',
        'key1' : 'value1'
      }, false);

      var fm3 = new FrozenMap.from({
        'key1': 'value2',
        'key2': 'value1',
        null : 'value3'
      }, false);

      // ordered Map
      var fm4 = new FrozenMap.from({
        'key2' : 'value2',
        null : 'value3',
        'key1' : 'value1'
      });

      // ordered Map
      var fm5 = new FrozenMap.from({
        null : 'value3',
        'key2' : 'value2',
        'key1' : 'value1'
      });

      expect(fm1 == fm2, isTrue);
      expect(fm1.hashCode == fm2.hashCode, isTrue);
      expect(fm1 == fm3, isFalse);
      expect(fm1.hashCode == fm3.hashCode, isFalse);
      expect(fm4 == fm5, isFalse);
    });
  });

}
