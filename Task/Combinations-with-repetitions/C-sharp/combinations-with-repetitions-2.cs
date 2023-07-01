using System;
class MultiCombination
{
  static string [] set = { "iced", "jam", "plain" };
  static int k = 2, n = set.Length;
  static string [] buf = new string [k];

  static void Main()
  {
    rec(0, 0);
  }

  static void rec(int ind, int begin)
  {
    for (int i = begin; i < n; i++)
    {
      buf [ind] = set[i];
      if (ind + 1 < k) rec(ind + 1, i);
      else Console.WriteLine(string.Join(",", buf));
    }
  }
}
