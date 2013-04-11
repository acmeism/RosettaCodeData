using System;
using System.Collections.Generic;
using System.Linq;

namespace RosettaGenerator
{
  class ListStyle
  {
    static void Main(string[] args)
    {
      IEnumerator<int> squaresGenerator = PowerGeneratorAsList(2);
      IEnumerator<int> cubesGenerator = PowerGeneratorAsList(3);

      IEnumerable<int> filter = FilterAsList(squaresGenerator, cubesGenerator);

      foreach (int value in filter.Skip(20).Take(10))
        Console.Write(value + " ");
      Console.WriteLine();
    }

    public static IEnumerator<int> PowerGeneratorAsList(int exponent)
    {
      int x = 0;
      while (true)
        yield return (int)Math.Pow(x++, exponent);
    }

    public static IEnumerable<int> FilterAsList(IEnumerator<int> squaresGenerator, IEnumerator<int> cubesGenerator)
    {
      int squareValue;
      int cubeValue = cubesGenerator.Current;
      while (true)
      {
        squareValue = squaresGenerator.Current;
        while (squareValue > cubeValue)
        {
          cubesGenerator.MoveNext();
          cubeValue = cubesGenerator.Current;
        }
        if (squareValue < cubeValue)
          yield return squareValue;
        squaresGenerator.MoveNext();
      }
    }
  }
}
