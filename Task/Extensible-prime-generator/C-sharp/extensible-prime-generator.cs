using System.Collections;

IEnumerable<int> StartSieve(int length)
{
    yield return 2;
    BitArray sieve = new(length);
    var i = 3;

    while (i < length)
    {
        if (!sieve[i])
        {
            yield return i;
            var j = i * i;

            while (j < length)
            {
                sieve[j] = true;
                j += i;
            }
        }

        i += 2;
    }
}

IEnumerable<int> AllPrimes()
{

    foreach (var prime in StartSieve(1000))
    {
        yield return prime;
    }

    var start = 1000;

    while (true)
    {
        foreach (var prime in Sieve(start, 1000))
        {
            yield return prime;
        }

        start += 1000;
    }
}

IEnumerable<int> Sieve(int start, int length)
{
    var sieve = new BitArray(length);

    foreach (var p in AllPrimes().Skip(1).TakeWhile(n => n * n < start + length))
    {
        var j = p * ((start + p - 1) / p);

        while (j < start + length)
        {
            sieve[j - start] = true;
            j += p;
        }
    }

    for (var j = 1 - (start % 2); j < length; j += 2)
    {
        if (!sieve[j])
            yield return start + j;
    }
}

Console.Write("First 20 primes:");

foreach (var p in AllPrimes().Take(20))
    Console.Write($" {p}");

Console.WriteLine();
Console.Write("Primes between 100 and 150:");

foreach (var p in Sieve(100, 50))
    Console.Write($" {p}");

Console.WriteLine();
Console.Write("Number of primes between 7700 and 8000:");
var n = Sieve(7700, 300).Count();
Console.WriteLine($" {n}");

Console.Write("10000th prime:");
var t = AllPrimes().Skip(9999).First();
Console.WriteLine($" {t}");
