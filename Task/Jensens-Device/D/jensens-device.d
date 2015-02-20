double sum(ref int i, in int lo, in int hi, lazy double term)
pure @safe /*nothrow @nogc*/ {
    double result = 0.0;
    for (i = lo; i <= hi; i++)
        result += term();
    return result;
}

void main() {
    import std.stdio;

    int i;
    sum(i, 1, 100, 1.0/i).writeln;
}
