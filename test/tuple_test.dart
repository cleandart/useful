library tuple_test;


import 'package:unittest/unittest.dart';
import 'package:useful/useful.dart';

class ElemMock {

  final dynamic val;

  ElemMock(this.val);

  operator ==(dynamic other){
    if(other is ElemMock){
      return this.val == other.val;
    } else {
      return false;
    }
  }

  get hashCode => val;

}

void main(){
  group('Tuple', (){

    test('get', (){
      var tp = new Tuple(1,2,3);
      expect(tp[0], equals(1));
      expect(tp[1], equals(2));
      expect(tp[2], equals(3));
      expect(tp.length, equals(3));
    });

    test('hashCode works correctly', (){
      var tp123 = new Tuple(1,2,3);
      var tp123b = new Tuple(1,2,3);
      var tpe = new Tuple();
      var tpeb = new Tuple();
      expect(tp123.hashCode, equals(tp123b.hashCode));
      expect(tpe.hashCode, equals(tpeb.hashCode));
      expect(tp123.hashCode!=tpe.hashCode, isTrue);
    });

    test('ordering', (){
      var tp123 = new Tuple(1,2,3);
      var tp123b = new Tuple(1,2,3);
      var tp12 = new Tuple(1,2);
      var tp23 = new Tuple(2,3);
      var te = new Tuple();
      var teb = new Tuple();

      expect(tp123 == tp123b, isTrue);
      expect(tp123 >= tp123b, isTrue);
      expect(tp123 <= tp123b, isTrue);

      expect(tp23 > tp123, isTrue);
      expect(tp123 > tp23, isFalse);
      expect(tp123 < tp23, isTrue);
      expect(tp23 < tp123, isFalse);

      expect(tp23 >= tp123, isTrue);
      expect(tp123 >= tp23, isFalse);
      expect(tp123 <= tp23, isTrue);
      expect(tp23 <= tp123, isFalse);

      expect(tp123 > tp12, isTrue);

      expect(te < tp123, isTrue);
      expect(te > tp123, isFalse);
      expect(te == teb, isTrue);

    });

    test('equality works without full ordering', (){
      var tp12 = new Tuple(new ElemMock(1), new ElemMock(2));
      var tp12b = new Tuple(new ElemMock(1), new ElemMock(2));
      var tp34 = new Tuple(new ElemMock(3), new ElemMock(4));
      expect(tp12 == tp12b, isTrue);
      expect(() => tp12 >= tp12b, throws);
      expect(() => tp12 > tp34, throws);
    });

    test('cunstructors are consistent', (){
      var tp12 = new Tuple(1,2);
      var tp123 = new Tuple(1,2,3);
      var tp12b = new Tuple.from([1,2]);
      var tp123b = new Tuple.from([1,2,3]);
      expect(tp12 == tp12b, isTrue);
      expect(tp123 == tp123b, isTrue);
      expect(tp12 == tp123, isFalse);
    });
  });

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
}

