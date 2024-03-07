using System;
using System.Numerics;

public class Program
{
    public static void Main(string[] args)
    {
        decimal ln2 = 0.6931471805599453094172m;
        decimal h = 0.5m / ln2;
        BigInteger w = new BigInteger();
        decimal f = 0;

        for (long i = 1; i <= 17; i++)
        {
            h = h * i / ln2;
            w = (BigInteger)h;
            f = h - (decimal)w;
            double y = (double)f;
            string d = y.ToString("0.000");

            Console.WriteLine($"n: {i,2}  h: {w}{d.Substring(1)}  Nearly integer: {d[2] == '0' || d[2] == '9'}");
        }
    }
}
