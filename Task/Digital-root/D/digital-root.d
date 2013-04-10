import std.stdio, std.typecons, std.conv, std.bigint;

Tuple!(int, T) digitalRoot(T)(T root, in uint base) /*pure nothrow*/
in {
    assert(base > 1);
} body {
    if (root < 0)
        root = -root;
    int persistence = 0;
    while (root >= base) {
        auto num = root;
        root = 0;
        while (num != 0) {
            root += num % base;
            num /= base;
        }
        persistence++;
    }
    return tuple(persistence, root);
}

void main() {
    // import std.stdio, std.conv, std.bigint;
    enum f1 = "%s(%d): additive persistance= %d, digital root= %d";
    foreach (b; [2, 3, 8, 10, 16, 36]) {
        foreach (n; [5, 627615, 39390, 588225, 393900588225])
            writefln(f1, to!string(n,b), b, digitalRoot(n, b).tupleof);
        writeln();
    }

    enum f2 = "<BIG>(%d): additive persistance= %d, digital root= %d";
    foreach (b; [2, 3, 8, 10, 16, 36]) {
        auto n = BigInt("58142718981673030403681039458302204471" ~
                       "300738980834668522257090844071443085937");
        writefln(f2, b, digitalRoot(n, b).tupleof); // shortened output
    }
}
