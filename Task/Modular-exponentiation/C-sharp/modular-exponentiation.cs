using System;
using System.Numerics;

class Program
{
    static void Main() {
        var a = BigInteger.Parse("2988348162058574136915891421498819466320163312926952423791023078876139");
        var b = BigInteger.Parse("2351399303373464486466122544523690094744975233415544072992656881240319");
        var m = BigInteger.Pow(10, 40);
        Console.WriteLine(BigInteger.ModPow(a, b, m));
    }
}
