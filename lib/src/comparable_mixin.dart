part of useful;

/**
 * Implements ==, >, <, >=, <=
 */
abstract class ComparableMixin{

  compareTo(var other);

  operator == (other){
    return this.compareTo(other) == 0;
  }

  operator > (other){
    return this.compareTo(other) == 1;
  }

  operator < (other){
    return this.compareTo(other) == -1;
  }

  operator >= (other){
    return this.compareTo(other) != -1;
  }

  operator <= (other){
    return this.compareTo(other) != 1;
  }

}