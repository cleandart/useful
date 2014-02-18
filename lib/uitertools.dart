part of useful;

class MmResult extends Tuple{

  get elem => this[0];
  get num => this[1];
  get keyVal => this[2];

  MmResult(elem, keyVal, index):super(elem, keyVal, index);

}

minmax(Iterable col, op, {key: null}){
  if(key==null){
    key = (elem) => elem;
  }
  var first = true;
  var minv = null;
  var mine = null;
  var _index=0;
  var index;
  for(var elem in col){
    var val = key(elem);
    if(elem is num && elem.isNaN){
      return new MmResult(elem, val, _index);
    }
    if(first){
      mine = elem;
      minv = val;
      index = _index;
      first = false;
    } else {
      if (op(val, minv)){
        mine = elem;
        minv = val;
        index = _index;
      }
    }
    _index++;
  };
  return new MmResult(mine, minv, index);
}

uminf(Iterable col, {key: null}){
  return minmax(col, (a,b) => a.compareTo(b)==-1, key:key);
}

umaxf(Iterable col, {key: null}){
  return minmax(col, (a,b) => a.compareTo(b)==1, key:key);
}

umin(Iterable col, {key:null}){
  return uminf(col, key:key).elem;
}

umax(Iterable col, {key:null}){
  return umaxf(col, key:key).elem;
}

sort(List input, {key:null, asc: true}) {
  if(key==null){
    key = (elem) => elem;
  }
  compareAsc(a, b){
    return key(a).compareTo(key(b));
  }
  compareDesc(a, b){
    return key(b).compareTo(key(a));
  }
  if (asc) {
    input.sort(compareAsc);
  } else {
    input.sort(compareDesc);
  }
}

forEachEI(Iterable iter, f){
  var i=0;
  for(var elem in iter){
    var res = f(elem, i++);
    if(res == false){
      break;
    }
  }
}


class DoubleMap{

  Map map1 = new Map();
  Map map2 = new Map();

  void add(x,y){
    var val = map1[x];
    map1[x]=y;
    map2[val] = null;
    map2[y]=x;

  }

  dynamic operator [](x){
    return get1(x);
  }

  dynamic get1(x){
    return map1[x];
  }

  dynamic get2(x){
    return map2[x];
  }

  void operator []=(x,y){
    add(x,y);
  }
}


math.Random rnd = new math.Random();

randomPerm(List input){

  swap(i,j){
    var tmp = input[i];
    input[i] = input[j];
    input[j] = tmp;
  }

  for(num index in new Range(input.length)){
      var newPlace = rnd.nextInt(index+1);
      swap(index, newPlace);
  };
}