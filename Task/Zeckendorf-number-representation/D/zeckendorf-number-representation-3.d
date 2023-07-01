import std.stdio, std.algorithm, std.range;

string zeckendorf(size_t n) {
    if (n == 0)
        return "0";
    auto fibs = recurrence!q{a[n - 1] + a[n - 2]}(1, 2);

    string result;
    foreach_reverse (immutable f; fibs.until!(x => x > n).array) {
        result ~= (f <= n) ? '1' : '0';
        if (f <= n)
            n -= f;
    }

    return result;
}

void main() {
    foreach (immutable i; 0 .. 21)
        writefln("%2d: %6s", i, i.zeckendorf);
}
