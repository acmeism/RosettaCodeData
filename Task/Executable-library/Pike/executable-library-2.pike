void main()
{
    .HailStone HailStone = .HailStone();

    mapping long = ([]);

    foreach (allocate(100000); int start; )
        long[sizeof(HailStone->hailstone(start))]++;

    analyze(long);
}

void analyze(mapping long)
{
    mapping max = ([ "count":0, "length":0 ]);
    foreach (long; int length; int count)
    {
        if (count > max->count)
        {
            max->length = length;
            max->count = count;
        }
    }
    write("most common length %d appears %d times\n", max->length, max->count);
}
