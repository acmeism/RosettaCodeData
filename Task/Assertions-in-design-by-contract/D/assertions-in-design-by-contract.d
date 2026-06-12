import std.stdio, std.algorithm, std.math;

double averageOfAbsolutes(in int[] values) pure nothrow @safe @nogc
in {
    // Pre-condition.
    assert(values.length > 0);
} out(result) {
    // Post-condition.
    assert(result >= 0);
} body {
    return values.map!abs.sum / double(values.length);
}

struct Foo {
    int x;
    void inc() { x++; }
    invariant {
        // Struct invariant.
        assert(x >= 0);
    }
}

void main() {
    [1, 3].averageOfAbsolutes.writeln;
    Foo f;
    f.inc;
}
