using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static Tuple<int, int> DigitalRoot(long num)
    {
        int mp = 0;
        while (num > 9)
        {
            num = num.ToString().ToCharArray().Select(x => x - '0').Aggregate((a, b) => a * b);
            mp++;
        }
        return new Tuple<int, int>(mp, (int)num);
    }
    static void Main(string[] args)
    {
        foreach (long num in new long[] { 123321, 7739, 893, 899998 })
        {
            var t = DigitalRoot(num);
            Console.WriteLine("{0} has multiplicative persistence {1} and multiplicative digital root {2}", num, t.Item1, t.Item2);
        }

        const int twidth = 5;
        List<long>[] table = new List<long>[10];
        for (int i = 0; i < 10; i++)
            table[i] = new List<long>();
        long number = -1;
        while (table.Any(x => x.Count < twidth))
        {
            var t = DigitalRoot(++number);
            if (table[t.Item2].Count < twidth)
                table[t.Item2].Add(number);
        }
        for (int i = 0; i < 10; i++)
            Console.WriteLine(" {0} : [{1}]", i, string.Join(", ", table[i]));
    }
}
