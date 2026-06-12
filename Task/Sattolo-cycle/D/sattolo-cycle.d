import std.stdio;

void main() {
    auto items = [0,1,2,3,4,5];
    sattoloCycle(items);
    items.writeln;
}

/// The Sattolo cycle is an algorithm for randomly shuffling an array in such a way that each element ends up in a new position.
void sattoloCycle(R)(R items) {
    import std.algorithm : swapAt;
    import std.random : uniform;

    for (int i=items.length; i-- > 1;) {
        int j = uniform(0, i);
        items.swapAt(i, j);
    }
}

unittest {
    import std.range : lockstep;
    auto o = ['a', 'b', 'c', 'd', 'e'];

    auto s = o.dup;
    sattoloCycle(s);
    foreach (a, b; lockstep(o, s)) {
        assert(a != b, "An element stayed in place unexpectedly.");
    }
}
