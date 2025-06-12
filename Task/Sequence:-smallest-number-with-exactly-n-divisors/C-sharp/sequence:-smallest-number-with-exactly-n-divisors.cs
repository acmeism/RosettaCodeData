using System.Numerics;
using static System.Console;

static int CountDivisors(int n)
{
    var count = 0;

    for (var i = 1; i * i <= n; i++)
        if ((n % i) == 0)
            count += i == n / i ? 1 : 2;

    return count;
}

Dictionary<int, BigInteger> memo = [];
var n = 0;
var start = DateTime.Now;

for (var count = 1; count <= 100; count++)
{
    Write($"{count}: ");

    // Did we already see this count from a smaller n?
    if (memo.TryGetValue(count, out var k))
    {
        WriteLine(k);
        continue;
    }

    // Count is prime or 1?
    if (CountDivisors(count) <= 2)
    {
        k = BigInteger.One << (count - 1);  // 2^(count-1)
        WriteLine(k);
        continue;
    }

    // Count is 2 × prime?
    if (count % 2 == 0 && CountDivisors(count / 2) == 2)
    {
        k = (BigInteger.One << (count / 2 - 1)) * 3;    // 3⁽²⁻¹⁾
        WriteLine(k);
        continue;
    }

    // Count is 3 × prime?
    if (count % 3 == 0 && CountDivisors(count / 3) == 2)
    {
        k = (BigInteger.One << (count / 3 - 1)) * 9;    // 3⁽³⁻¹⁾
        WriteLine(k);
        continue;
    }

    // Count is 4 × prime?
    if (count >= 16 && count % 4 == 0 && CountDivisors(count / 4) == 2)
    {
        // 4 is factored as 2x2 giving 3⁽²⁻¹⁾5⁽²⁻¹⁾ = 3·5 which is less than 3⁽⁴⁻¹⁾ = 27
        k = (BigInteger.One << (count / 4 - 1)) * 15;
        WriteLine(k);
        continue;
    }

    // Etc.
    if (count >= 25 && count % 5 == 0 && CountDivisors(count / 5) == 2)
    {
        k = (BigInteger.One << (count / 5 - 1)) * 81;  // 3⁽⁵⁻¹⁾
        WriteLine(k);
        continue;
    }

    if (count >= 36 && count % 6 == 0 && CountDivisors(count / 6) == 2)
    {
        k = (BigInteger.One << (count / 6 - 1)) * 45;   // 3⁽³⁻¹⁾5⁽²⁻¹⁾ = 9·5
        WriteLine(k);
        continue;
    }

    if (count >= 49 && count % 7 == 0 && CountDivisors(count / 7) == 2)
    {
        k = (BigInteger.One << (count / 7 - 1)) * 729;   // 3⁽⁷⁻¹⁾
        WriteLine(k);
        continue;
    }

    // Otherwise just try each number until we find a match
    while (true)
    {
        ++n;
        var d = CountDivisors(n);

        if (d == count)
            break;

        // Save this one for later
        if (d > count && !memo.ContainsKey(d))
            memo[d] = n;
    }

    WriteLine(n);
}

WriteLine($"Elapsed time: {(DateTime.Now - start).TotalMilliseconds:0}ms");
