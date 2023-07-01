typedef Accumulator = num Function(num);

Accumulator makeAccumulator(num s) => (num n) => s += n;
