import std.stdio, std.algorithm, std.range;

bool isPrime2(Integer)(in Integer number) pure nothrow {
  // Adapted from: http://www.devx.com/vb2themax/Tip/19051
  // manually test 1, 2, 3 and multiples of 2 and 3
  if (number == 2 || number == 3)
    return true;
  else if (number < 2 || number % 2 == 0 || number % 3 == 0)
    return false;

  /* we can now avoid to consider multiples
   * of 2 and 3. This can be done really simply
   * by starting at 5 and incrementing by 2 and 4
   * alternatively, that is:
   *    5, 7, 11, 13, 17, 19, 23, 25, 29, 31, 35, 37, ...
   * we don't need to go higher than the square root of the number */
  for (Integer divisor = 5, increment = 2; divisor*divisor <= number;
       divisor += increment, increment = 6 - increment)
    if (number % divisor == 0)
      return false;

  return true; // if we get here, the number is prime
}

void main() { // demo code
    iota(2, 40).filter!isPrime2().writeln();
}
