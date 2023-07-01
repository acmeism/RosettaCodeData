typedef Accumulator = num Function(num);

Accumulator makeAccumulator(num initial) {
  num s = initial;
  num accumulator(num n) {
    s += n;
    return s;
  }
  return accumulator;
}
