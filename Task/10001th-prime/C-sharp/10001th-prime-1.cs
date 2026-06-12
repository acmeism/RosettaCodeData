using System; class Program {

  static bool isprime(uint p ) { if ((p & 1) == 0) return p == 2;
    if ((p % 3) == 0) return p == 3;
    for (uint i = 5, d = 4; i * i <= p; i += (d = 6 - d))
      if (p % i == 0) return false; return true; }

  static uint prime(uint n) { uint p, d, pn;
    for (p = 5, d = 4, pn = 2; pn < n; p += (d = 6 - d))
      if (isprime(p)) pn++; return p - d; }

  static void Main(string[] args) {
    Console.WriteLine("One-at-a-time trial division vs sieve of Eratosthenes");
    var sw = System.Diagnostics.Stopwatch.StartNew();
    var t = prime(10001); sw.Stop(); double e1, e2;
    Console.Write("{0:n0} {1} ms", prime(10001),
      e1 = sw.Elapsed.TotalMilliseconds);
    sw.Restart(); uint n = 105000, i, j; var pr = new uint[10100];
    pr[0] = 2; pr[1] = 3; uint pc = 2, r, d, ii;
    var pl = new bool[n + 1]; r = (uint)Math.Sqrt(n);
    for (i = 9; i < n; i += 6) pl[i] = true;
    for (i = 5, d = 4; i <= r; i += (d = 6 - d)) if (!pl[i]) {
      pr[pc++] = i; for (j = i * i, ii = i << 1; j <= n; j += ii)
        pl[j] = true; }
    for ( ;i <= n; i += (d = 6 - d)) if (!pl[i]) pr[pc++] = i;
    t = pr[10000]; sw.Stop();
    Console.Write("  {0:n0} {1} μs  {2:0.000} times faster", t,
      (e2 = sw.Elapsed.TotalMilliseconds) * 1000.0, e1 / e2); } }
