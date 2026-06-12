// First file: Cycles.cs
// Author: Paul Anton Chernoch

using System;

namespace DetectCycles
{
  /// <summary>
  /// Find the length and start of a cycle in a series of objects of any IEquatable type using Brent's cycle algorithm.
  /// </summary>
  public class Cycles<T> where T : IEquatable<T>
  {
    /// <summary>
    /// Find the cycle length and start position of a series using Brent's cycle algorithm.
    ///
    ///  Given a recurrence relation X[n+1] = f(X[n]) where f() has
    ///  a finite range, you will eventually repeat a value that you have seen before.
    ///  Once this happens, all subsequent values will form a cycle that begins
    ///  with the first repeated value. The period of that cycle may be of any length.
    /// </summary>
    /// <returns>A tuple where:
    ///    Item1 is lambda (the length of the cycle)
    ///    Item2 is mu, the zero-based index of the item that started the first cycle.</returns>
    /// <param name="x0">First item in the series.</param>
    /// <param name="yielder">Function delegate that generates the series by iterated execution.</param>
    public static Tuple<int,int> FindCycle(T x0, Func<T,T> yielder)
    {
      int power, lambda;
      T tortoise, hare;
      power = lambda = 1;
      tortoise = x0;
      hare = yielder(x0);

      // Find lambda, the cycle length
      while (!tortoise.Equals (hare)) {
        if (power == lambda) {
          tortoise = hare;
          power *= 2;
          lambda = 0;
        }
        hare = yielder (hare);
        lambda += 1;
      }

      // Find mu, the zero-based index of the start of the cycle
      var mu = 0;
      tortoise = hare = x0;
      for (var times = 0; times < lambda; times++)
        hare = yielder (hare);

      while (!tortoise.Equals (hare))
      {
        tortoise = yielder (tortoise);
        hare = yielder (hare);
        mu += 1;
      }

      return new Tuple<int,int> (lambda, mu);
    }
  }
}

// Second file: Program.cs

using System;

namespace DetectCycles
{
	class MainClass
	{
		public static void Main (string[] args)
		{
			// A recurrence relation to use in testing
			Func<int,int> sequence = (int _x) => (_x * _x + 1) % 255;

			// Display the first 41 numbers in the test series
			var x = 3;
			Console.Write(x);
			for (var times = 0; times < 40; times++)
			{
				x = sequence(x);
				Console.Write(String.Format(",{0}", x));
			}
			Console.WriteLine();

			// Test the FindCycle method
			var cycle = Cycles<int>.FindCycle(3, sequence);
			var clength = cycle.Item1;
			var cstart = cycle.Item2;
			Console.Write(String.Format("Cycle length = {0}\nStart index = {1}\n", clength, cstart));
		}
	}
}

