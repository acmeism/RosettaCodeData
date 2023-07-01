using System;
using System.Collections.Generic;
using System.Linq;
using static System.Console;

namespace LinearCongruentialGenerator
{
    static class LinearCongruentialGenerator
    {
        static int _seed = (int)DateTime.Now.Ticks; // from bad random gens might as well have bad seed!
        static int _bsdCurrent = _seed;
        static int _msvcrtCurrent = _seed;

        static int Next(int seed, int a, int b) => (a * seed + b) & int.MaxValue;

        static int BsdRand() => _bsdCurrent = Next(_bsdCurrent, 1103515245, 12345);

        static int MscvrtRand() => _msvcrtCurrent = Next (_msvcrtCurrent << 16,214013,2531011) >> 16;

        static void PrintRandom(int count, bool isBsd)
        {
            var name = isBsd ? "BSD" : "MS";
            WriteLine($"{name} next {count} Random");
            var gen = isBsd ? (Func<int>)(BsdRand) : MscvrtRand;
            foreach (var r in Enumerable.Repeat(gen, count))
                WriteLine(r.Invoke());
        }

        static void Main(string[] args)
        {
            PrintRandom(10, true);
            PrintRandom(10, false);
            Read();
        }
    }
}
