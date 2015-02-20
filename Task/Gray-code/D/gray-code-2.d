import std.stdio, std.algorithm;

T[] gray(int N : 1, T)() pure nothrow {
    return [T(0), 1];
}

/// Recursively generate gray encoding mapping table.
T[] gray(int N, T)() pure nothrow if (N <= T.sizeof * 8) {
    enum T M = T(2) ^^ (N - 1);
    T[] g = gray!(N - 1, T)();
    foreach (immutable i; 0 .. M)
        g ~= M + g[M - i - 1];
    return g;
}

T[][] grayDict(int N, T)() pure nothrow {
    T[][] dict = [gray!(N, T)(), [0]];
    // Append inversed gray encoding mapping.
    foreach (immutable i; 1 .. dict[0].length)
        dict[1] ~= countUntil(dict[0], i);
    return dict;
}

enum M { Encode = 0, Decode = 1 }

T gray(int N, T)(in T n, in int mode=M.Encode) pure nothrow {
    // Generated at compile time.
    enum dict = grayDict!(N, T)();
    return dict[mode][n];
}

void main() {
    foreach (immutable i; 0 .. 32) {
        immutable encoded = gray!(5)(i, M.Encode);
        immutable decoded = gray!(5)(encoded, M.Decode);
        writefln("%2d: %5b => %5b : %2d", i, i, encoded, decoded);
    }
}
