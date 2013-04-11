using System;
using System.Collections.Generic;
using System.Linq;

namespace RosettaGenerator
{
  class ClosureStyle
  {
    static void Main(string[] args)
    {
      Func<int> squaresGenerator = PowerGeneratorAsClosure(2);
      Func<int> cubesGenerator = PowerGeneratorAsClosure(3);

      Func<int> filter = FilterAsClosure(squaresGenerator, cubesGenerator);

      foreach (int i in Enumerable.Range(0, 20))
        filter();
      foreach (int i in Enumerable.Range(21, 10))
        Console.Write(filter() + " ");
      Console.WriteLine();
    }

    public static Func<int> PowerGeneratorAsClosure(int exponent)
    {
      int x = 0;
      return () => { return (int)Math.Pow(x++, exponent); };
    }

    public static Func<int> FilterAsClosure(Func<int> squaresGenerator, Func<int> cubesGenerator)
    {
      int squareValue;
      int cubeValue = cubesGenerator();
      return () =>
      {
        while (true)
        {
          squareValue = squaresGenerator();
          while (squareValue > cubeValue)
            cubeValue = cubesGenerator();
          if (squareValue < cubeValue)
            return squareValue;
        }
      };
    }
  }
}
