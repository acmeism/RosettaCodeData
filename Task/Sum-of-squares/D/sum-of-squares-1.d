T sumSquares(T)(T[] a) pure nothrow @safe @nogc {
    T sum = 0;
    foreach (e; a)
        sum += e ^^ 2;
    return sum;
}

void main() {
    import std.stdio: writeln;

    [3.1, 1.0, 4.0, 1.0, 5.0, 9.0].sumSquares.writeln;
}
