T[][] permutations(T)(T[] items) pure nothrow {
    T[][] result;

    void perms(T[] s, T[] prefix=[]) nothrow {
        if (s.length)
            foreach (immutable i, immutable c; s)
               perms(s[0 .. i] ~ s[i+1 .. $], prefix ~ c);
        else
            result ~= prefix;
    }

    perms(items);
    return result;
}

version (permutations1_main) {
    void main() {
        import std.stdio;
        writefln("%(%s\n%)", [1, 2, 3].permutations);
    }
}
