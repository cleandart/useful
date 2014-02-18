library priority_map_test;

import 'package:unittest/unittest.dart';
import 'package:useful/useful.dart';

void main(){
  group('PriorityMap', (){

    test('basic map fn', (){
      var pm = new PriorityMap();
      pm['hello'] = 1;
      pm['world'] = 2;
      expect(pm['hello'], equals(1));
      expect(pm['world'], equals(2));
      pm.remove('hello');
      expect(pm['hello'], isNull);
    });

    test('ordering', (){
      PriorityMap pm = new PriorityMap();
      pm['are'] = 3;
      pm['you'] = 4;
      pm['how'] = 2;
      pm['hello'] = 1;
      List ordered = [];
      for(num i=0; i<4; i++){
        var key = pm.first;
        ordered.add(key);
        pm.remove(key);
      }
      expect(ordered.join(' '), equals('hello how are you'));
    });

    test('getFirst on empty map returns null', (){
      PriorityMap pm = new PriorityMap();
      expect(pm.first, isNull);
    });


  });
}

