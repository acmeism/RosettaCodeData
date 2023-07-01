struct Fraction {
  public uint d;
  public uint n;
}

void farey(uint n) {
  Fraction f1 = {0, 1};
  Fraction f2 = {1, n};
  print("0/1 1/%u ", n);
  while (f2.n > 1) {
    var k = (n + f1.n) / f2.n;
    var aux = f1;
    f1 = f2;
    f2 = {f2.d * k - aux.d, f2.n * k - aux.n};
    print("%u/%u ", f2.d, f2.n);
  }
  print("\n");
}

uint fareyLength(uint n, uint[] cache) {
  if (n >= cache.length) {
    uint newLen = cache.length;
    if (newLen == 0)
      newLen = 16;
    while (newLen <= n)
      newLen *= 2;
    cache.resize((int)newLen);
  }
  else if (cache[n] != 0)
    return cache[n];

  uint length = n * (n + 3) / 2;
  for (uint p = 2, q = 2; p <= n; p = q) {
    q = n / (n / p) + 1;
    length -= fareyLength(n / p, cache) * (q - p);
  }

  cache[n] = length;
  return length;
}

void main() {
  for (uint n = 1; n < 12; n++)
  {
    print("%8u: ", n);
    farey(n);
  }

  uint[] cache = new uint[0];
  for (uint n = 100; n <= 1000; n += 100)
    print("%8u: %14u items\n", n, fareyLength(n, cache));
}
