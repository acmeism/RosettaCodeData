int i = 0, count = 0, limit = 500;
Console.WriteLine("The first 50 forbidden numbers are:");

for (; count < 50; ++i)
{
    if (isForbidden(i))
    {
        Console.Write($"{i} ");
        ++count;
        if (count % 10 == 0) Console.WriteLine();
    }
}

Console.WriteLine();

for (i = 1, count = 0; ; ++i)
{
    if (isForbidden(i)) ++count;
    if (i == limit)
    {
        Console.WriteLine($"Forbidden number count <= {limit}: {count}");
        if (limit == 500000000) break;
        limit *= 10;
    }
}

static bool isForbidden(int number)
{
    int copyNumber = number;
    int powerOf4 = 0;

    while (copyNumber > 1 && copyNumber % 4 == 0)
    {
        copyNumber /= 4;
        powerOf4 += 1;
    }

    return (number / Math.Pow(4, powerOf4)) % 8 == 7;
}

