using System;
using System.Collections.Generic;
using System.Linq;

class Program {
    static void Main(string[] args) {
            int[,] a = new int[10, 10];
            Random r = new Random();

            // prepare linq statement with two 'from' which makes nested loop
            var pairs = from i in Enumerable.Range(0, 10)
                        from j in Enumerable.Range(0, 10)
                        select new { i = i, j = j};

            // iterates through the full nested loop with a sigle foreach statement
            foreach (var p in pairs)
            {
                a[p.i, p.j] = r.Next(0, 21) + 1;
            }

            // iterates through the nested loop until find element = 20
            pairs.Any(p => { Console.Write(" {0}", a[p.i, p.j]); return a[p.i, p.j] == 20; });
            Console.WriteLine();
    }
}
