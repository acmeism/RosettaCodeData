using System;
using static System.Console;
using LI = System.Collections.Generic.SortedSet<int>;

class Program {

  static LI unl(LI res, LI set, int lft, int mul = 1, int vlu = 0) {
    if (lft == 0) res.Add(vlu);
    else if (lft > 0) foreach (int itm in set)
      res = unl(res, set, lft - itm, mul * 10, vlu + itm * mul);
    return res; }

  static void Main(string[] args) { WriteLine(string.Join(" ",
      unl(new LI {}, new LI { 2, 3, 5, 7 }, 13))); }
}
