int[][] zigZag(in int n) pure nothrow @safe {
    static void move(in int n, ref int i, ref int j)
    pure nothrow @safe @nogc {
        if (j < n - 1) {
            if (i > 0) i--;
            j++;
        } else
            i++;
    }

    auto a = new int[][](n, n);
    int x, y;
    foreach (v; 0 .. n ^^ 2) {
        a[y][x] = v;
        (x + y) % 2 ? move(n, x, y) : move(n, y, x);
    }
    return a;
}

void main() {
    import std.stdio;

    writefln("%(%(%2d %)\n%)", 5.zigZag);
}
