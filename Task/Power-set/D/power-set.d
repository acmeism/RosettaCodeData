import std.stdio;

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
    writeln(powerSet([1, 2, 3]));
}
