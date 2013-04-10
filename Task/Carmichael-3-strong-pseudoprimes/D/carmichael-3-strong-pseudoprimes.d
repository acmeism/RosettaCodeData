import std.stdio, sieve_of_eratosthenes3;

int mod(in int n, in int m) pure nothrow {
  return ((n % m) + m) % m;
}

void main() {
  foreach (immutable p; 2 .. 62) {
    if (!p.IsPrime) continue;
    foreach (immutable h3; 2 .. p) {
      immutable g = h3 + p;
      foreach (immutable d; 1 .. g) {
        if ((g * (p - 1)) % d != 0 || mod(-p * p, h3) != d % h3)
          continue;
        immutable q = 1 + (p - 1) * g / d;
        if (!q.IsPrime) continue;
        immutable r = 1 + (p * q / h3);
        if (!r.IsPrime || (q * r) % (p - 1) != 1) continue;
        writeln(p, " x ", q, " x ", r);
      }
    }
  }
}
