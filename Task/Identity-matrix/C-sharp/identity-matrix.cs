using System;
using System.Linq;

namespace IdentityMatrix
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length != 1)
            {
                Console.WriteLine("Requires exactly one argument");
                return;
            }
            int n;
            if (!int.TryParse(args[0], out n))
            {
                Console.WriteLine("Requires integer parameter");
                return;
            }

            var identity =
                Enumerable.Range(0, n).Select(i => Enumerable.Repeat(0, n).Select((z,j) => j == i ? 1 : 0).ToList()).ToList();
            foreach (var row in identity)
            {
                foreach (var elem in row)
                {
                    Console.Write(" " + elem);
                }
                Console.WriteLine();
            }
            Console.ReadKey();
        }
    }
}
