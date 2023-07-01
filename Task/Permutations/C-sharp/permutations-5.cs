using System;
class Permutations
{
  static int n = 4;
  static int [] buf = new int [n];
  static bool [] used = new bool [n];

  static void Main()
  {
    for (int i = 0; i < n; i++) used [i] = false;
    rec(0);
  }

  static void rec(int ind)
  {
    for (int i = 0; i < n; i++)
    {
      if (!used [i])
      {
        used [i] = true;
        buf [ind] = i;
	if (ind + 1 < n) rec(ind + 1);
        else Console.WriteLine(string.Join(",", buf));
	used [i] = false;
      }
    }
  }
}
