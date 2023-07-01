using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

private static void Main(string[] args)
{
  int j = 0, m = 0;
  decimal[] n = {12757923, 12878611, 12757923, 15808973, 15780709, 197622519};
  var l = new List<int>[n.Length];

  Parallel.For(0, n.Length, i => { l[i] = getPrimes(n[i]); });

  for (int i = 0; i<n.Length; i++)
    if (l[i].Min()>m)
    {
      m = l[i].Min();
      j = i;
    }

  Console.WriteLine("Number {0} has largest minimal factor:", n[j]);
  foreach (int list in l[j])
    Console.Write(" "+list);
}
