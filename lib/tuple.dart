part of useful;

class Identifier{

  final String name;

  const Identifier([this.name = 'identifier']);

  toString(){
    return '$name';
  }
}

const noArg = const Identifier('noArg');

Tpl([a1=noArg, a2=noArg, a3=noArg, a4=noArg, a5=noArg, a6=noArg, a7=noArg]){
  return new Tuple(a1, a2, a3, a4, a5, a6, a7);
}

/**
 * Immutable List-like structure. Delegates equality, hashing and
 * comparable operations to its elements. This means:
 *
 *     Tpl(1,2,3) == Tpl(1,2,3) // true
 *     Tpl(1,8,9) > Tpl(2,8,9) // true because 2>1
 *     Tpl(1,2,9) > Tpl(1,3,9) // true because 3>2
 *
 *     var key1 = Tpl(1,2,3)
 *     var key2 = Tpl(1,2,3)
 *     var map = {key1: 'hello world'};
 *     map[key2] // equals 'hello world'
 *
 *     words = ['aaa', 'bb', 'c', 'ddd'];
 *     sort(words, key: (word) => Tpl(word.length, word)) // sorts words by length
 *     // and alphabeticaly, when length equals
 *
 *
 */
class Tuple extends Iterable with IterableMixin, ComparableMixin implements Comparable {

  List _data;
  num _hash;

  Tuple([a1=noArg, a2=noArg, a3=noArg, a4=noArg, a5=noArg, a6=noArg, a7=noArg]){
    _data=[];
    if(a1!=noArg){
      _data.add(a1);
    }
    if(a2!=noArg){
      _data.add(a2);
    }
    if(a3!=noArg){
      _data.add(a3);
    }
    if(a4!=noArg){
      _data.add(a4);
    }
    if(a5!=noArg){
      _data.add(a5);
    }
    if(a6!=noArg){
      _data.add(a6);
    }
    if(a7!=noArg){
      _data.add(a7);
    }
    _computeHash();
  }

  Tuple.from(Iterable data){
    _data = new List.from(data);
    _computeHash();
  }

  get length => _data.length;

  Iterator get iterator => _data.iterator;

  compareTo(var other){
      var minl = math.min(this.length, other.length);
      for(int i=0; i<minl; i++){
        var res = this[i].compareTo(other[i]);
        if(res!=0){
          return res;
        }
      }
      if(this.length>other.length){
        return 1;
      } else if(this.length<other.length){
        return -1;
      }
      return 0;
    }

  operator [](int i){
    return _data[i];
  }

  operator ==(other){
    if(other is Tuple){
      if(this._hash != other.hashCode || this.length != other.length){
        return false;
      }
      for(int i=0; i<this.length;i++){
        if(this[i] != other[i]){
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
  }

  int get hashCode => _hash;

  _computeHash(){
    _hash = 17;
    this.forEach((data){
      _hash = _hash*31 + data.hashCode;
      _hash %= 2<<31;
    });
  }

  toString(){
    return 'Tuple(${_data.toString().substring(0)})';
  }
}


