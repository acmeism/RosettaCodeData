// Square-free integers
using System;

class Program
{
  // Return true if n has no square divisors other than 1
  static bool SqFree(uint n)
  {
    // quick exit for most common square
    bool result = (n % 4 != 0);
    uint i = 3;
    uint sq = i * i;
    while (sq <= n && result)
    {
      if (n % sq == 0)
        result = false;
      else
      {
        i += 2;
        sq = i * i;
      }
    }
    return result;
  }

  // Report number of square-free integers up to limit
  static void Report(uint limit)
  {
    Console.Write("Square-free integers up to {0,6}: ", limit);
    uint c = 0;
    for (uint i = 1; i <= limit; i++)
      if (SqFree(i))
        c++;
    Console.WriteLine("{0,5} were found.", c);
  }

  static void Main()
  {
    uint c = 0;
    Console.WriteLine("Square free integers up to 145:");
    for (uint i = 1; i <= 145; i++)
      if (SqFree(i))
      {
        Console.Write("{0,4}", i);
        c++;
        if (c % 10 == 0)
          Console.WriteLine();
      }
    Console.WriteLine("{0} were found.", c);
    Console.WriteLine();
    Report(100);
    Report(1000);
    Report(10000);
    Report(100000);
  }
}
