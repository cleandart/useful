part of useful;

class FrozenSet extends Iterable with IterableMixin{
//  implements Set

  Set _data;
  Tuple _tuple;
  num _hash;

  FrozenSet(){
    _data = new Set();
    _computeHash();
  }

  FrozenSet.from(Iterable iter){
    _data = new Set.from(iter);
    _computeHash();
  }

  contains(key){
    return _data.contains(key);
  }

  containsAll(iter){
    return _data.containsAll(iter);
  }

  int get hashCode => _hash;

  get iterator{
    return _data.iterator;
  }

  _computeHash(){
    _hash = 0;
    _data.forEach((elem){
      _hash += elem.hashCode;
    });
    _hash %= 2<<31;
  }

  int get length => _data.length;

  operator ==(other){
    if(other is FrozenSet){
      if(other.hashCode != this.hashCode){
        return false;
      } else {
        return this.length == other.length && this.containsAll(other);
      }
    } else {
      return false;
    }
  }

}