using System;
using System.Numerics;
using System.Linq;
class Program
{
    static BigInteger factorial(int n) // iterative
    {
        BigInteger acc = 1; for (int i = 1; i <= n; i++) acc *= i; return acc;
    }

    static public BigInteger Factorial(int number) // functional
    {
        return Enumerable.Range(1, number).Aggregate(new BigInteger(1), (acc, num) => acc * num);
    }

    static public BI FactorialQ(int number) // functional quick, uses prodtree method
    {
        var s = Enumerable.Range(1, number).Select(num => new BI(num)).ToArray();
        int top = s.Length, nt, i, j;
        while (top > 1) {
            for (i = 0, j = top, nt = top >> 1; i < nt; i++) s[i] *= s[--j];
            top = nt + ((top & 1) == 1 ? 1 : 0);
        }
        return s[0];
    }

    static void Main(string[] args)
    {
        Console.WriteLine(Factorial(250));
    }
}
