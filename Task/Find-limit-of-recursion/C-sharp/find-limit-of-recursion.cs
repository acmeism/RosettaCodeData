using System;
class RecursionLimit
{
  static void Main(string[] args)
  {
    Recur(0);
  }

  private static void Recur(int i)
  {
    Console.WriteLine(i);
    Recur(i + 1);
  }
}
