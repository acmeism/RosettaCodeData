void main() {
    import std.stdio, std.algorithm;

    auto a = [9, 8, 7, 6, 5, 0, 1, 2, 3, 4];
    foreach (immutable i; 0 .. a.length) {
        a.topN(i);
        write(a[i], " ");
    }
}
