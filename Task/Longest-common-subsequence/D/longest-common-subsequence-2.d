import std.stdio, std.algorithm, std.traits;

T[] lcs(T)(in T[] a, in T[] b) pure /*nothrow*/ {
    auto L = new uint[][](a.length + 1, b.length + 1);

    foreach (immutable i; 0 .. a.length)
        foreach (immutable j; 0 .. b.length)
            L[i + 1][j + 1] = (a[i] == b[j]) ? (1 + L[i][j]) :
                              max(L[i + 1][j], L[i][j + 1]);

    Unqual!T[] result;
    for (auto i = a.length, j = b.length; i > 0 && j > 0; ) {
        if (a[i - 1] == b[j - 1]) {
            result ~= a[i - 1];
            i--;
            j--;
        } else
            if (L[i][j - 1] < L[i - 1][j])
                i--;
            else
                j--;
    }

    result.reverse(); // Not nothrow.
    return result;
}

void main() {
    lcs("thisisatest", "testing123testing").writeln;
}
