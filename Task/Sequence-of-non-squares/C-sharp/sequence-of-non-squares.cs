using System;
using System.Diagnostics;

namespace sons
{
    class Program
    {
        static void Main(string[] args)
        {
            for (int i = 1; i < 23; i++)
                Console.WriteLine(nonsqr(i));

            for (int i = 1; i < 1000000; i++)
            {
                double j = Math.Sqrt(nonsqr(i));
                Debug.Assert(j != Math.Floor(j),"Square");
            }
        }

        static int nonsqr(int i)
        {
            return (int)(i + Math.Floor(0.5 + Math.Sqrt(i)));
        }
    }
}
