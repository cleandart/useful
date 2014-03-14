import 'package:unittest/unittest.dart';
import 'package:useful/useful.dart';
import 'dart:math' as math;

void main(){
  var sentence;

  setUp((){
    sentence = "beta alpha charlieee delta fidgi epsilon".split(" ");
  });

  group('MinMaxSort', (){
    test('min max basics', (){
      var nums = [3,4,5,1,2,3];
      expect(uminf(nums), equals(new MmResult(1, 1, 3)));
      expect(umin(nums), equals(1));
      expect(umaxf(nums), equals(new MmResult(5, 5, 2)));
      expect(umax(nums), equals(5));

      // it works with strings too
      expect(umin(sentence), equals("alpha"));
      expect(umax(sentence), equals("fidgi"));
    });

    test('min max with key', (){
      expect(uminf(sentence, key: (word) => word.length), equals(new MmResult('beta', 4, 0)));
      expect(umaxf(sentence, key: (word) => word.length), equals(new MmResult('charlieee', 9, 2)));
    });

    test('NaN and Infinity are working properly', (){
      List<double> nums = [3,4,5,1,double.NAN,2,3];
      expect(umin(nums).isNaN, isTrue);
      nums = [3,4,5,1,double.INFINITY,-double.INFINITY,2,3];
      expect(umin(nums).isInfinite, isTrue);
      expect(umin(nums).isNegative, isTrue);
      expect(umax(nums).isInfinite, isTrue);
      expect(umax(nums).isNegative, isFalse);
    });

    test('sort works properly', (){
      sort(sentence);
      expect(sentence, orderedEquals(['alpha', 'beta', 'charlieee', 'delta', 'epsilon', 'fidgi']));
      sort(sentence, key: (word) => Tpl(word.length, word));
      expect(sentence, orderedEquals(['beta', 'alpha', 'delta', 'fidgi', 'epsilon', 'charlieee']));
      sort(sentence, key: (word) => Tpl(word.length, word), asc: false);
      expect(sentence, orderedEquals(['charlieee', 'epsilon', 'fidgi', 'delta', 'alpha', 'beta']));
    });

  });

  group('Random perm', (){
    test('random perm spec', (){
      var nums = [1,2,3,4,5];
      var count={};
      var n = 100000;

      for(num i=0; i<n; i++){
        var _nums = new List.from(nums);
        randomPerm(_nums);
        var tp = new Tuple.from(_nums);
        if(count.containsKey(tp)){
          count[tp]++;
        } else {
          count[tp] = 1;
        }
      }
      var ex = n~/120;
      var tolerance = 6*math.sqrt(ex).round();
      expect(count.keys.length, equals(120));
      count.forEach((k,v){
        expect((v-ex).abs(), lessThan(tolerance));
      });
    });
  });

  group('generator', (){
    test('generator spec', (){
      // given
      var g = generator((yield){
        num i=0;
        return (){
          if (i>5) throw new StopIteration();
          for(int j=0; j<i; j++){
            yield(i);
          }
          i++;
        };
      });
      // then
      expect(new List.from(g), orderedEquals([1,2,2,3,3,3,4,4,4,4,5,5,5,5,5]));
    });

    test('ugenerator spec', (){
      f(){
        num i=0;
        return (){
          if (i>5) throw new StopIteration();
          return i++;
        };
      }
      var g;
      for(num i in [1,2]){
        g = ugenerator(f());
        expect(new List.from(g), orderedEquals([0,1,2,3,4,5]));
      }
    });

    test('yielding multiple values', (){
      f(yield){
        num i=0;
        return (){
          if (i>2) throw new StopIteration();
          yield(i);
          yield(i+1);
          i+=2;
        };
      }
      var g = generator(f);
      expect(new List.from(g), orderedEquals([0,1,2,3]));
    });

  });

  group('variations', (){

    checkUnique(Tuple v){
      Set used = new Set();
      for(var i in v){
        expect(i, lessThanOrEqualTo(5));
        expect(i, greaterThanOrEqualTo(1));
        used.add(i);
      }
      expect(used.length, v.length);
    }

    prettify(Iterable vars){
      Set res = new Set();
      for(var v in vars){
        var tv = new Tuple.from(v);
        checkUnique(tv);
        res.add(tv);
      }
      return res;
    }

    test('variations spec', (){
      Set res = prettify(variations([1,2,3,4,5],3));
      expect(res.length, equals(5*4*3));
    });

    test('permutations', (){
      Set res = prettify(permutations([1,2,3,4,5]));
      expect(res.length, equals(5*4*3*2));
    });

    test('order 0, empty input', (){
      Set res = prettify(variations([],0));
      expect(res, unorderedEquals([Tpl()]));
    });

    test('order 0, non-empty input', (){
      Set res = prettify(variations([1,2,3,4,5],0));
      expect(res, unorderedEquals([Tpl()]));
    });

    test('order greater than input length', (){
      expect(() => variations([1,2,3,4,5],6), throws);
    });
  });

  group('combinations', (){

    checkUnique(v){
      Set used = new Set();
      for(var i in v){
        expect(i, lessThanOrEqualTo(5));
        expect(i, greaterThanOrEqualTo(1));
        used.add(i);
      }
      expect(used.length, v.length);
    }

    prettify(Iterable vars){
      Set res = new Set();
      for(var v in vars){
        var tv = new FrozenSet.from(v);
        checkUnique(tv);
        res.add(tv);
      }
      return res;
    }

    test('combinations basics', (){
      var res = prettify(combinations([1,2,3,4,5],3));
      expect(res.length, 5*4*3/2/3);
    });

    test('order zero', (){
      var res = prettify(combinations([1,2,3,4,5],0));
      expect(res, unorderedEquals([new FrozenSet()]));
    });

    test('order max', (){
      var res = prettify(combinations([1,2,3,4,5],5));
      expect(res, unorderedEquals([new FrozenSet.from([1,2,3,4,5])]));
    });

    test('empty input, order 0', (){
      var res = prettify(combinations([],0));
      expect(res, unorderedEquals([new FrozenSet()]));
    });

    test('order too big throws', (){
      expect(() => combinations([1,2,3,4,5],6), throws);
    });

  });

  test('sum',(){
    expect(sum([]), equals(0));
    expect(sum([1,2,3]), equals(6));
  });

}

