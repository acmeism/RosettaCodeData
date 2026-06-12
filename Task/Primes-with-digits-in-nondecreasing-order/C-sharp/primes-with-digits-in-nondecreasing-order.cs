using System.Linq; using System.Collections.Generic; using static System.Console; using static System.Math;

class Program {

  static int ba; static string chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

  // convert an int into a string using the current ba
  static string from10(int b) { string res = ""; int re; while (b > 0) {
    b = DivRem(b, ba, out re); res = chars[(byte)re] + res; } return res; }

  // parse a string into an int, using current ba (not used here)
  static int to10(string s) { int res = 0; foreach (char i in s)
    res = res * ba + chars.IndexOf(i); return res; }

  // note: comparing the index of the chars instead of the chars themsleves, which avoids case issues
  static bool nd(string s) { if (s.Length < 2) return true;
    char l = s[0]; for (int i = 1; i < s.Length; i++)
      if (chars.IndexOf(l) > chars.IndexOf(s[i]))
        return false; else l = s[i] ; return true; }

  static void Main(string[] args) { int c, lim = 1000; string s;
    foreach (var b in new List<int>{ 2, 3, 4, 5, 6, 7, 8, 9, 10, 16, 17, 27, 31, 62 }) {
      ba = b; c = 0; foreach (var a in PG.Primes(lim))
        if (nd(s = from10(a))) Write("{0,4} {1}", s, ++c % 20 == 0 ? "\n" : "");
    WriteLine("\nBase {0}: found {1} non-decreasing primes under {2:n0}\n", b, c, from10(lim)); } } }

class PG { public static IEnumerable<int> Primes(int lim) {
    var flags = new bool[lim + 1]; int j; yield return 2;
    for (j = 4; j <= lim; j += 2) flags[j] = true; j = 3;
    for (int d = 8, sq = 9; sq <= lim; j += 2, sq += d += 8)
      if (!flags[j]) { yield return j;
        for (int k = sq, i = j << 1; k <= lim; k += i) flags[k] = true; }
    for (; j <= lim; j += 2) if (!flags[j]) yield return j; } }
