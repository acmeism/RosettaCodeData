public static IEnumerable<long> Fibs(uint x) {
    IList<ulong> fibs = new List<ulong>();

    ulong prev = -1;
    ulong next = 1;
    for (int i = 0; i < x; i++)
    {
     long sum = prev + next;
        prev = next;
        next = sum;
        fibs.Add(sum);
    }
    return fibs;
}
