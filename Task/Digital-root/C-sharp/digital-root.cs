using System;
using System.Linq;

class Program
{
    static Tuple<int, int> DigitalRoot(long num)
    {
        int additivepersistence = 0;
        while (num > 9)
        {
            num = num.ToString().ToCharArray().Sum(x => x - '0');
            additivepersistence++;
        }
        return new Tuple<int, int>(additivepersistence, (int)num);
    }
    static void Main(string[] args)
    {
        foreach (long num in new long[] { 627615, 39390, 588225, 393900588225 })
        {
            var t = DigitalRoot(num);
            Console.WriteLine("{0} has additive persistence {1} and digital root {2}", num, t.Item1, t.Item2);
        }
    }
}
