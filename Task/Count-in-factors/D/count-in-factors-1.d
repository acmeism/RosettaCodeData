int[] factorize(in int n) pure nothrow
in {
    assert(n > 0);
} body {
    if (n == 1) return [1];
    int[] result;
    int m = n, k = 2;
    while (n >= k) {
        while (m % k == 0) {
            result ~= k;
            m /= k;
        }
        k++;
    }
    return result;
}

void main() {
    import std.stdio;
    foreach (i; 1 .. 22)
        writefln("%d: %(%d × %)", i, i.factorize());
}
