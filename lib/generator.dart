part of useful;

class StopIteration implements Exception {
  final String message;

  const StopIteration([this.message = ""]);

  String toString() => "StopIteration: $message";

}

class _Iterable extends Iterable with IterableMixin {

  dynamic fun;

  _Iterable(this.fun);

  get iterator{
    return new _Iterator(this.fun);
  }

}


class _Iterator extends Iterator {

  dynamic fun;
  dynamic value;
  Queue yields;
  var afterLast = false;

  _Iterator(_fun){
    yields = new Queue();
    this.fun = _fun(this.yield);
    value = null;
    afterLast = false;
  }

  yield(var val){
    yields.addLast(val);
  }

  get current{
    return value;
  }

  moveNext(){
    if (afterLast) {
      return false;
    }
    while(yields.isEmpty){
      try {
        fun();
      } on StopIteration catch (e) {
        afterLast = true;
        return false;
      }
    }
    value = yields.removeFirst();
    return true;
  }
}

generator(fun){
  return new _Iterable(fun);
}

/**
 * create simply Iterable without the need for implementing Iterable and Iterator.
 *
 *     test('generator spec', (){
 *     // given
 *     var g = generator((yield){
 *       num i=0;
 *       return (){
 *         if (i>5) throw new StopIteration();
 *         for(int j=0; j<i; j++){
 *           yield(i);
 *         }
 *         i++;
 *       };
 *     });
 *     // then
 *     expect(new List.from(g), orderedEquals([1,2,2,3,3,3,4,4,4,4,5,5,5,5,5]));
 *   });
 *
 *   Inside generating function, [yield] is called on generated values; [yield]
 *   can be called multiple (or even zero) times.
 *
 *   End of iteration is expressed Python-style by throwing StopIteration exception
 */

ugenerator(f) => generator((yield) => (){yield(f());});

