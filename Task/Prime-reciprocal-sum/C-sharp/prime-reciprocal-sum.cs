using System.Numerics;
using System.Security.Cryptography;

Console.WriteLine(2);
BigInteger n = 1;
BigInteger d = 2;

while (true)
{
    var p = (d / n) | 1;

    while (!p.IsProbablePrime(10))
    {
        p += 2;
    }

    var s = p.ToString();

    if (s.Length < 40)
        Console.WriteLine(s);
    else
        Console.WriteLine($"{s[..19]}..{s[^19 ..]} ({s.Length} digits)");

    (n, d) = (p * n - d, p * d);
    var g = BigInteger.GreatestCommonDivisor(n, d);
    (n, d) = (n / g, d / g);
}
