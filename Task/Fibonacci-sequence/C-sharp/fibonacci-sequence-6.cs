public static IEnumerable<ulong> Fibs(uint x) {
    ulong prev = -1;
    ulong next = 1;
    for (uint i = 0; i < x; i++) {
        ulong sum = prev + next;
        prev = next;
        next = sum;
        yield return sum;
    }
}
