part of useful;

num mean(Iterable i) => sum(i)/i.length;

num stdev(Iterable i) {
  var m = mean(i);
  return math.sqrt(sum(i.map((x) => (x - m) * (x - m))) / i.length);
}
