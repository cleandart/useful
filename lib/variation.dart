part of useful;

const noElem = const Object();

_cv(Iterable _input, num order, isVars) {

  List input = new List.from(_input);
  num n = input.length;

  if(order > input.length){
    throw new Exception('size input (${input.length}) must be >= than order of the variation (${order})');
  }

  return (yield) {
    DoubleMap positions;
    positions = null;

    makeRes(){
      var res = isVars?[]:new Set();
      for(num i in range(order)){
        res.add(input[positions.get2(i)]);
      }
      return res;
    }

    positions = new DoubleMap();
    for(num i in range(n)){
      if(i<order){
        positions[i] = i;
      } else {
        positions[i] = noElem;
      }
    }

    yield(makeRes());

    findPlace(int what, int start) {
      num i;
      for (i=start; (i < n) && (positions[i] != noElem); i++);
      return i<n?i:-1;
    }

    findNext(){
      if(order == 0){
        throw new StopIteration();
      }
      var move;

      // find the lowest-priority pointer that can be moved
      for(num i=order-1; i>=0; i--){
        num oldPlace = positions.get2(i);
        // the pointer may not be set at all
        if(oldPlace == null){
          continue;
        }
        num place = findPlace(i, oldPlace+1);
        positions[oldPlace] = noElem;
        if(place>=0){
          // we can move the pointer
          positions[place] = i;
          move = i;
          break;
        } else {
          // pointer cannot be moved, higher-priority pointer must be moved, or
          // iteration must be stopped
          if(i==0){
            throw new StopIteration();
          }
        }
      }
      num i;
      // try to place all missing pointers
      bool shouldYield = true;
      for (i=move+1; i<order; i++) {
        num startPlace = isVars?0:positions.get2(i-1);
        num place = findPlace(i, startPlace);
        // if pointer cannot be placed, yield nothing
        if(place == -1){
          shouldYield = false;
          break;
        }
        positions[place] = i;
      }
      if(shouldYield) {
        yield(makeRes());
      }
    }
    return findNext;
  };
}

_variations(input, order) => _cv(input, order, true);
_combinations(input, order) => _cv(input, order, false);

/**
 * creates Iterable of variations of given iterable and order
 */
Iterable variations(Iterable input, int order) => generator(_variations(input, order));

/**
 * creates Iterable of combinations of given iterable and order
 */
Iterable combinations(Iterable input, int order) => generator(_combinations(input, order));

/**
 * creates Iterable of permutations of given iterable
 */
Iterable permutations(Iterable input) => variations(input, input.length);
