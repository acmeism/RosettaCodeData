import std.stdio, std.algorithm, std.traits;

T[] lcs(T)(in T[] a, in T[] b) pure /*nothrow*/ {
    auto L = new int[][](a.length + 1, b.length + 1);
    Unqual!T[] result;
    int i, j;

    for (i = 0; i < a.length; i++)
        for (j = 0; j < b.length; j++)
            L[i+1][j+1] = (a[i] == b[j]) ? (1 + L[i][j]) :
                          max(L[i+1][j], L[i][j+1]);

    while (i > 0 && j > 0)
        if (a[i - 1] == b[j - 1]) {
            result ~= a[i - 1];
            i--;
            j--;
        } else
            if (L[i][j - 1] < L[i - 1][j])
                i--;
            else
                j--;

    result.reverse(); // not nothrow
    return result;
}

void main() {
    writeln(lcs("thisisatest", "testing123testing"));
}
