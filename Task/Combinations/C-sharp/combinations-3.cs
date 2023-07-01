using System;
class Combinations
{
  static int k = 3, n = 5;
  static int [] buf = new int [k];

  static void Main()
  {
    rec(0, 0);
  }

  static void rec(int ind, int begin)
  {
    for (int i = begin; i < n; i++)
    {
      buf [ind] = i;
      if (ind + 1 < k) rec(ind + 1, buf [ind] + 1);
      else Console.WriteLine(string.Join(",", buf));
    }
  }
}
