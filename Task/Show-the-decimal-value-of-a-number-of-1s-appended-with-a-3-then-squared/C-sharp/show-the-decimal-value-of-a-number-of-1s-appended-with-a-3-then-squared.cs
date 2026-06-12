using System; using BI = System.Numerics.BigInteger;
class Program { static void Main(string[] args) {
    for (BI x = 3; BI.Log10(x) < 22; x = (x - 2) * 10 + 3)
      Console.WriteLine("{1,43} {0,-20}", x, x * x); } }
