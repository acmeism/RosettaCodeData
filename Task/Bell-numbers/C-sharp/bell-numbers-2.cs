using System.Numerics;

foreach (var row in BellTriangle().Take(15))
{
    Console.WriteLine(row[0]);
}

Console.WriteLine(BellTriangle().ElementAt(49)[0]);

foreach (var row in BellTriangle().Take(10))
{
    Console.WriteLine(string.Join(", ", row));
}

IEnumerable<List<BigInteger>> BellTriangle()
{
    List<BigInteger> row = [1];

    while (true)
    {
        yield return row;
        var scan = row[^1];
        row = [scan, .. row.Select(r => scan += r) ];
    }
}
