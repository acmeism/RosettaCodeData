using System; using System.Numerics;
using static System.Math; using static System.Console;

static class Program
{
    static string CalcE(int nDigs)
    {
        int pad = (int)Round(Log10(nDigs)), n = 1;
        BigInteger f = BigInteger.Pow(10, nDigs + pad), e = f + f;
        do e += (f /= ++n); while (f > n);
        return (e / BigInteger.Pow(10, pad + 1)).ToString().Insert(1, ".");
    }

    static void Main()
    {
        WriteLine(Exp(1));  //  double precision built-in function
        WriteLine(CalcE(100));   //  arbitrary precision result
        DateTime st = DateTime.Now; int qmil = 250_000;
        string es = CalcE(qmil);  //  large arbitrary precision result string
        WriteLine("{0:n0} digits in {1:n3} seconds.", qmil, (DateTime.Now - st).TotalSeconds);
        WriteLine("partial: {0}...{1}", es.Substring(0, 46), es.Substring(es.Length - 45));
    }
}
