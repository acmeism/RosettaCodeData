import std.algorithm, std.array, std.typecons, std.range;

auto sPermutations(in int n) /*pure nothrow*/ {
    static int[][] sPermu(in int items) /*pure nothrow*/ {
        if (items <= 0)
            return [[]];
        typeof(return) r;
        foreach (immutable i, item; sPermu(items - 1)) {
            //r.put((i % 2 ? iota(cast(int)item.length, -1, -1) :
            //               iota(item.length + 1))
            //      .map!(i => item[0..i] ~ (items-1) ~ item[i..$]));
            immutable f=(in int i)=>item[0..i] ~ (items-1) ~ item[i..$];
            r ~= (i % 2) ?
                 iota(cast(int)item.length, -1, -1).map!f.array :
                 iota(item.length + 1).map!f.array;
        }
        return r;
    }

    return sPermu(n).zip([1, -1].cycle);
}

void main() {
    import std.stdio;
    foreach (immutable n; [3, 4]) {
        writefln("\nPermutations and sign of %d items", n);
        foreach (const tp; n.sPermutations)
            writefln("Perm: %s Sign: %2d", tp[]);
    }
}
