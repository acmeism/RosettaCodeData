using System.Numerics;

for (var i = 0; i < 5; i++)
{
    var length = Random.Shared.Next(3, 6);
    List<BigInteger> list = [];

    for (var j = 0; j < length; j++)
    {
        list.Add(Random.Shared.Next(1_000_000));
    }

    var r = Rank(list);
    Console.WriteLine($"rank({string.Join(", ", list)}) = {r}");
    Console.WriteLine($"unrank({r}) = {string.Join(", ", Unrank(r))}");
    list.Add(length);
    Console.WriteLine($"  Count of bits in list = {list.Sum(m => Math.Log2((double)m)):0.0}");
    Console.WriteLine($"  Count of bits in rank = {Math.Log2((double)r):0.0}");
}

for (var n = 0; n <= 10; n++)
{
    var list = Unrank(n, 3);
    var m = Rank(list, 3);
    Console.WriteLine($"{n}: [{string.Join(", ", list)}] : {m}");
}

const int DefaultBias = 10;

static BigInteger Rank(List<BigInteger> list, int bias = DefaultBias)
{
    list.ForEach(m => ArgumentOutOfRangeException.ThrowIfNegativeOrZero(m, nameof(list)));
    if (list.Count == 0) return 0;
    BigInteger n = 0;
    List<int> digits = [];
    var first = true;

    foreach (var m in list)
    {
        if (!first) digits.Add(bias - 1);
        first = false;
        digits.AddRange(ToBijectiveBase(m - 1, bias - 1));
    }

    return 1 + FromBijectiveBase(digits, bias);
}

static List<BigInteger> Unrank(BigInteger n, int bias = DefaultBias)
{
    if (n-- == 0) return [];
    var list = ToBijectiveBase(n, bias);
    var i = 0;
    List<BigInteger> result = [];
    List<int> digits = [];
    BigInteger m;

    while (i < list.Count)
    {
        while (i < list.Count && list[i] != bias - 1)
        {
            digits.Add(list[i]);
            i++;
        }

        if (i < list.Count)
        {
            m = FromBijectiveBase(digits, bias - 1);
            result.Add(m + 1);
            digits.Clear();
            i++;
        }
    }

    m = FromBijectiveBase(digits, bias - 1);
    result.Add(m + 1);
    return result;
}

static BigInteger FromBijectiveBase(IEnumerable<int> digits, int @base)
{
    BigInteger n = 0;

    foreach (var i in digits)
    {
        var a = i + 1;
        if (a == @base) { a = 0; n++; }
        n = n * @base + a;
    }

    return n;
}

static List<int> ToBijectiveBase(BigInteger n, int @base)
{
    List<int> list = [];

    while (n > 0)
    {
        var q = (n + (@base - 1)) / @base - 1;
        var a = n - q * @base;
        list.Add((int)a - 1);
        n = q;
    }

    list.Reverse();
    return list;
}
