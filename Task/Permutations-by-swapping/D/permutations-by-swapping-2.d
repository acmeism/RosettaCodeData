import std.algorithm, std.array, std.typecons, std.range;

auto sPermutations(in uint n) pure nothrow @safe {
    static immutable(int[])[] inner(in int items) pure nothrow @safe {
        if (items <= 0)
            return [[]];
        typeof(return) r;
        foreach (immutable i, immutable item; inner(items - 1)) {
            //r.put((i % 2 ? iota(item.length.signed, -1, -1) :
            //               iota(item.length + 1))
            //      .map!(i => item[0 .. i] ~ (items - 1) ~ item[i .. $]));
            immutable f = (in size_t i) pure nothrow @safe =>
                item[0 .. i] ~ (items - 1) ~ item[i .. $];
            r ~= (i % 2) ?
                 //iota(item.length.signed, -1, -1).map!f.array :
                 iota(item.length + 1).retro.map!f.array :
                 iota(item.length + 1).map!f.array;
        }
        return r;
    }

    return inner(n).zip([1, -1].cycle);
}

void main() {
    import std.stdio;
    foreach (immutable n; [2, 3, 4]) {
        writefln("Permutations and sign of %d items:", n);
        foreach (immutable tp; n.sPermutations)
            writefln("  %s Sign: %2d", tp[]);
        writeln;
    }
}
