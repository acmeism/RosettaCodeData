import std.stdio, std.math, std.string, std.conv;

bool isPrime(int n) {
  if (n <= 1)
    return false;
  foreach (i; 2 .. cast(int)sqrt(cast(real)n) + 1)
    if (!(n % i))
      return false;
  return true;
}

bool isTruncatablePrime(bool left)(int n) {
  string s = to!string(n);
  if (indexOf(s, '0') != -1)
    return false;
  foreach (i; 0 .. s.length)
    static if (left) {
      if (!isPrime(to!int(s[i .. $])))
        return false;
    } else {
      if (!isPrime(to!int(s[0 .. i+1])))
        return false;
    }
  return true;
}

void main() {
  enum int n = 1_000_000;
  foreach_reverse (i; 2 .. n)
    if (isTruncatablePrime!true(i)) {
      writeln("Largest left-truncatable prime in 2 .. ", n, ": ", i);
      break;
    }
  foreach_reverse (i; 2 .. n)
    if (isTruncatablePrime!false(i)) {
      writeln("Largest right-truncatable prime in 2 .. ", n, ": ", i);
      break;
    }
}
