// Periodic table
using System;

class PeriodicTable
{
  private static readonly int[] aArray = {1, 2, 5, 13, 57, 72, 89, 104};
  private static readonly int[] bArray = {-1, 15, 25, 35, 72, 21, 58, 7};

  public void RowAndColumn(int n, out int r, out int c)
  {
    int i = 7;
    while (aArray[i] > n)
      i--;
    int m = n + bArray[i];
    r = m / 18 + 1;
    c = m % 18 + 1;
  }
}

class Program
{
  public static void Main()
  {
    PeriodicTable pt = new PeriodicTable();
    // Example elements (atomic numbers).
    int[] nums = new int[]{1, 2, 29, 42, 57, 58, 72, 89, 90, 103};
    foreach (var n in nums)
    {
      int r, c;
      pt.RowAndColumn(n, out r, out c);
      Console.Write(String.Format("{0,3:###} ->", n));
      Console.WriteLine(String.Format("{0,2:##}{1,3:###}", r, c));
    }
  }
}
