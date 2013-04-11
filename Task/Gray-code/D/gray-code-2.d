import std.stdio, std.conv, std.algorithm;

T[] gray(int N : 1, T)() { return [to!T(0), 1]; }

/// recursively generate gray encoding mapping table
T[] gray(int N, T)() pure nothrow {
    assert(N <= T.sizeof * 8, "N exceed number of bit of T");
    enum T M = to!T(2) ^^ (N - 1);
    T[] g = gray!(N - 1, T)();
    foreach (i; 0 .. M)
        g ~= M + g[M - i - 1];
    return g;
}

T[][] grayDict(int N, T)() {
    T[][] dict = [gray!(N, T)(), [0]];
    // append inversed gray encoding mapping
    foreach (i; 1 .. dict[0].length)
        dict[1] ~= countUntil(dict[0], i);
    return dict;
}

enum M { Encode = 0, Decode = 1 };

T gray(int N, T)(in T n, in int mode=M.Encode) {
    // generated at compile time
    enum dict = grayDict!(N, T)();
    return dict[mode][n];
}

void main() {
    foreach (i; 0 .. 32) {
        immutable encoded = gray!(5)(i, M.Encode);
        immutable decoded = gray!(5)(encoded, M.Decode);
        writefln("%2d: %5b => %5b : %2d", i, i, encoded, decoded);
    }
}
