using System; using static System.Console;
class Program {
  const int lmt = (int)1e6, first = 2500; static int[] f = new int[10];
  static void Main(string[] args) {
    f[0] = 1; for (int a = 0, b = 1; b < f.Length; a = b++)
      f[b] = f[a] * (b + 1);
    int pc = 0, nth = 0, lv = 0;
    for (int i = 2; i < lmt; i++) if (is_erdos_prime(i)) {
        if (i < first) Write("{0,5:n0}{1}", i, pc++ % 5 == 4 ? "\n" : "  ");
        nth++; lv = i; }
    Write("\nCount of Erdős primes between 1 and {0:n0}: {1}\n{2} Erdős prime (the last one under {3:n0}): {4:n0}", first, pc, ord(nth), lmt, lv); }

  static string ord(int n) {
    return string.Format("{0:n0}", n) + new string[]{"th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th"}[n % 10]; }

  static bool is_erdos_prime(int p) {
    if (!is_pr(p)) return false; int m = 0, t;
    while ((t = p - f[m++]) > 0) if (is_pr(t)) return false;
    return true;
    bool is_pr(int x) {
      if (x < 4) return x > 1; if ((x & 1) == 0) return false;
      for (int i = 3; i * i <= x; i += 2) if (x % i == 0) return false;
    return true; } } }
