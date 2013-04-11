import std.algorithm, std.array, std.typecons, std.range;

Tuple!(int[], int)[] sPermutations(in int n) /*pure nothrow*/ {
    static int[][] sPermu(in int items) /*pure nothrow*/ {
        if (items <= 0)
            return [[]];
        typeof(return) r;
        foreach (i, item; sPermu(items - 1)) {
            if (i % 2)
                r ~= iota(cast(int)item.length, -1, -1)
                     .map!(i => item[0..i] ~ (items-1) ~ item[i..$])()
                     .array();
            else
                r ~= iota(item.length + 1)
                     .map!(i => item[0..i] ~ (items-1) ~ item[i..$])()
                     .array();
        }
        return r;
    }

    auto r = sPermu(n);
    return iota(r.length)
           .map!(i => tuple(r[i], i % 2 ? -1 : 1))()
           .array();
}

void main() {
    import std.stdio;
    foreach (n; [3, 4]) {
        writefln("\nPermutations and sign of %d items", n);
        foreach (tp; sPermutations(n))
            writefln("Perm: %s Sign: %2d", tp.tupleof);
    }
}
