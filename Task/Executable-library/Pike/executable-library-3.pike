void main()
{
    mapping long = ([]);

    foreach (allocate(100000); int start; )
        long[sizeof(.Hailstone.hailstone(start))]++;

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
