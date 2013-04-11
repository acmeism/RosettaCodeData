void main() {
    import std.stdio;
    enum n = 5;
    int[n][n] M;
    int pos, side = n;

    foreach (i; 0 .. (n / 2 + n % 2)) {
        foreach (j; 0 .. side)
            M[i][i + j] = pos++;
        foreach (j; 1 .. side)
            M[i + j][n - 1 - i] = pos++;
        foreach_reverse (j; 0 .. side - 1)
            M[n - 1 - i][i + j] = pos++;
        foreach_reverse (j; 1 .. side - 1)
            M[i + j][i] = pos++;
        side -= 2;
    }

    writefln("%(%(%2d %)\n%)", M);
}
