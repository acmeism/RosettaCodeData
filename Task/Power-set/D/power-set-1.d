T[][] powerSet(T)(in T[] s) pure nothrow {
    auto r = new typeof(return)(1, 0);
    foreach (e; s) {
        typeof(return) rs;
        foreach (x; r)
            rs ~= x ~ [e];
        r ~= rs;
    }
    return r;
}

void main() {
    import std.stdio;
    [1, 2, 3].powerSet.writeln;
}
