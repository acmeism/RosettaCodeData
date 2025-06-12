using System.Numerics;

static BigInteger Derivative(BigInteger k)
{
    if (k < 0) return -Derivative(-k);
    if (k < 2) return 0;
    if (k.IsEven) return 2 * Derivative(k / 2) + k / 2;
    BigInteger m = 3;

    while (m * m <= k && (k % m) != 0)
        m += 2;

    var n = k / m;
    if (m * n != k || m == 1 || n == 1) return 1;
    return n * Derivative(m) + m * Derivative(n);
}

for (var i = -99; i <= 100; i++)
{
    Console.Write($"{Derivative(i),6}");
    if (i % 10 == 0) Console.WriteLine();
}

BigInteger p = 1;

for (var n = 1; n <= 20; n++)
{
    p *= 10;
    Console.WriteLine($"⅐ D(10^{n}) = {Derivative(p) / 7}");
}
