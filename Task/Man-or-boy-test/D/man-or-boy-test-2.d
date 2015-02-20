int A(int k, int delegate() nothrow @safe[] x...) nothrow @safe {
    int b() nothrow @safe {
        k--;
        return A(k, &b, x[0], x[1], x[2], x[3]);
    }

    return (k > 0) ? b() : x[3]() + x[4]();
}

void main() {
    import std.stdio;

    A(10, 1, -1, -1, 1, 0).writeln;
}
