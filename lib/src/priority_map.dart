part of useful;


/**
 * Map - like structure, that also indexes Map's values using TreeMap;
 * therefore it should be possible to easily traverse values in increasing/decreasing
 * manner.
 *
 * possible use:
 *
 *     timeToVisit = new PriorityMap();
 *     timeToVisit['moe'] = 123;
 *     timeToVisit['guybrush'] = 234;
 *     timeToVisit['arthur'] = 12;
 *
 *     firstToVisit = timeToVisit.first // equals 'arthur'
 */

//TODO: implement all map functions
class PriorityMap {

  var _data;
  var _tree;

  PriorityMap(){
    this._data = {};
    this._tree = new SplayTreeMap((Tuple key1, Tuple key2){
      return key1[1].compareTo(key2[1]);
    });
  }

  containsKey(key){
    return _data.containsKey(key);
  }

  add(key, val){
    if(this.containsKey(key)){
      this.remove(key);
    }
    var record = new Tuple(key, val);
    _data[key] = val;
    _tree[record] = null;
  }

  remove(key){
    var val = _data[key];
    var record = new Tuple(key, val);
    _tree.remove(record);
    _data.remove(key);
  }

  get first{
    Tuple key = _tree.firstKey();
    if(key == null){
      return null;
    }
    return key[0];
  }

  get isEmpty => _data.isEmpty;

  operator [](key){
     return _data[key];
  }

  operator []=(key, val){
    return add(key,val);
  }

}
