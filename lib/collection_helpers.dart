
mapEq(Map m1, Map m2){
  if (m1 == null && m2 == null) return true;
  if (m1 == null || m2 == null) return false;
  return m1.keys.length == m2.keys.length && m1.keys.every((k) => m1[k]==m2[k]);
}