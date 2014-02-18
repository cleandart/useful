import 'dart:math';

void main() {
  var nan = 1/0 - 1/0;
  print(nan);
  print(1>nan);
  print(1<nan);
  print(nan>1);
  print(nan<1);
  print(nan==nan);
  print(nan is num);
  print(min(nan,3));
  print(min(0.0,-0.0));
  print(min(-0.0,0.0));
  print(0.0 == -0.0);



}
