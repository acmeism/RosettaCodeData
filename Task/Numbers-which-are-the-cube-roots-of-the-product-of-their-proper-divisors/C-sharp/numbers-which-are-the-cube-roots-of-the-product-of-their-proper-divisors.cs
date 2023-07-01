using System;
class Program {

  static bool dc8(uint n) {
    uint res = 1, count, p, d;
    for ( ; (n & 1) == 0; n >>= 1) res++;
    for (count = 1; n % 3 == 0; n /= 3) count++;
    for (p = 5, d = 4; p * p <= n; p += d = 6 - d)
        for (res *= count, count = 1; n % p == 0; n /= p) count++;
    return n > 1 ? res * count == 4 : res * count == 8;
  }

  static void Main(string[] args) {
    Console.WriteLine("First 50 numbers which are the cube roots of the products of "
                      + "their proper divisors:");
    for (uint n = 1, count = 0, lmt = 500; count < 5e6; ++n) if (n == 1 || dc8(n))
        if (++count <= 50) Console.Write("{0,3}{1}",n, count % 10 == 0 ? '\n' : ' ');
        else if (count == lmt) Console.Write("{0,16:n0}th: {1:n0}\n", count, n, lmt *= 10);
  }
}
