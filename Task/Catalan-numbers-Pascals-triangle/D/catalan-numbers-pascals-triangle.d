void main() {
    import std.stdio;

    enum uint N = 15;
    uint[N + 2] t;
    t[1] = 1;

    foreach (immutable i; 1 .. N + 1) {
        foreach_reverse (immutable j; 2 .. i + 1)
            t[j] += t[j - 1];
        t[i + 1] = t[i];
        foreach_reverse (immutable j; 2 .. i + 2)
            t[j] += t[j - 1];
        write(t[i + 1] - t[i], ' ');
    }
}
