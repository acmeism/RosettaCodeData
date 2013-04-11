using System;
using System.Diagnostics;
using System.Linq;
using System.Numerics;

static class Program {
    static void Main() {
        BigInteger n = BigInteger.Pow(5, (int)BigInteger.Pow(4, (int)BigInteger.Pow(3, 2)));
        string result = n.ToString();

        Debug.Assert(result.Length == 183231);
        Debug.Assert(result.StartsWith("62060698786608744707"));
        Debug.Assert(result.EndsWith("92256259918212890625"));

        Console.WriteLine("n = 5^4^3^2");
        Console.WriteLine("n = {0}...{1}",
            result.Substring(0, 20),
            result.Substring(result.Length - 20, 20)
            );

        Console.WriteLine("n digits = {0}", result.Length);
    }
}
