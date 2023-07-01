using System;
class Permutations
{
  static int n = 4;
  static int [] buf = new int [n];
  static int [] next = new int [n+1];

  static void Main()
  {
    for (int i = 0; i < n; i++) next [i] = i + 1;
    next[n] = 0;
    rec(0);
  }

  static void rec(int ind)
  {
    for (int i = n; next[i] != n; i = next[i])
    {
      buf [ind] = next[i];
      next[i]=next[next[i]];
      if (ind < n - 1) rec(ind + 1);
      else Console.WriteLine(string.Join(",", buf));
      next[i] = buf [ind];
    }
  }
}
