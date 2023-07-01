void main() {
    import std.stdio, std.range, std.algorithm, std.typecons;

    enum uint MAX = 250;
    uint[ulong] p5;
    Tuple!(uint, uint)[ulong] sum2;

    foreach (immutable i; 1 .. MAX) {
        p5[ulong(i) ^^ 5] = i;
        foreach (immutable j; i .. MAX)
            sum2[ulong(i) ^^ 5 + ulong(j) ^^ 5] = tuple(i, j);
    }

    const sk = sum2.keys.sort().release;
    foreach (p; p5.keys.sort())
        foreach (immutable s; sk) {
            if (p <= s)
                break;
            if (p - s in sum2) {
                writeln(p5[p], " ", tuple(sum2[s][], sum2[p - s][]));
                return; // Finds first only.
            }
        }
}
