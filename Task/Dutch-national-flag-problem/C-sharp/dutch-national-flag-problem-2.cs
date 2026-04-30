// Dutch national flag problem
using System;

class DutchFlagProblem
{
  enum Color {Blue, White, Red};

  static void WriteColorSeq(Color[] t)
  {
    uint n = (uint)t.Length;
    for (uint i = 0; i < n; i++)
    {
      switch (t[i])
      {
        case Color.Blue:
          Console.Write("B");
          break;
        case Color.White:
          Console.Write("W");
          break;
        case Color.Red:
          Console.Write("R");
          break;
      };
    }
    Console.WriteLine();
  }

  static void Swap(ref Color x, ref Color y)
  {
    Color temp = x;
    x = y;
    y = temp;
  }

  static void SortByColor(Color[] t)
  {
    uint b = 0, w = 0, r = (uint)t.Length - 1;
    while (w <= r)
    {
      switch (t[w])
      {
        case Color.White:
          w++;
          break;
        case Color.Blue:
          Swap(ref t[b], ref t[w]);
          b++;
          w++;
          break;
        case Color.Red:
          Swap(ref t[w], ref t[r]);
          r--;
          break;
      }
    }
  }

  static void Main()
  {
    const uint N = 20;
    Color[] t = new Color[N];

    // Set colors
    Random rand = new Random();
    for (uint i = 0; i < N; i++)
      t[i] = (Color)(rand.Next(3));

    Console.WriteLine("Unsorted:");
    WriteColorSeq(t);
    SortByColor(t);
    Console.WriteLine();
    Console.WriteLine("Sorted:");
    WriteColorSeq(t);
  }
}
