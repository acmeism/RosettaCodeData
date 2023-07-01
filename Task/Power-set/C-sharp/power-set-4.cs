using System;
class Powerset
{
  static int n = 4;
  static int [] buf = new int [n];

  static void Main()
  {
    rec(0, 0);
  }

  static void rec(int ind, int begin)
  {
    for (int i = begin; i < n; i++)
    {
      buf [ind] = i;
      for (int j = 0; j <= ind; j++) Console.Write("{0, 2}", buf [j]);
      Console.WriteLine();
      rec(ind + 1, buf [ind] + 1);
    }
  }
}
