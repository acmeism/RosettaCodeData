IEnumerable<int> Fusc()
{
    yield return 1;
    var n = 1;

    foreach (var f in Fusc())
    {
        yield return n + f;
        yield return f;
        n = f;
    }
}

IEnumerable<int> ContFrac(int n, int d)
{
    while (d != 0)
    {
        yield return n / d;
        (n, d) = (d, n % d);
    }
}

Console.WriteLine("First 20 terms of the Calkin-Wilf sequence:");
var n = 1;

foreach (var f in Fusc().Take(20))
{
    Console.Write($"{n}/{f} ");
    n = f;
}

Console.WriteLine();
var bits = 0L;
var bit = 1L;
var shift = 0;

foreach (var c in ContFrac(83116, 51639))
{
    for (var i = 0; i < c; i++)
    {
        bits |= bit << shift;
        shift++;
    }

    bit = 1 - bit;
}

Console.WriteLine($"83116/51639 is at position {bits} in the sequence");
