import std.stdio, std.bigint;

void main() {
    int ndigits = 0;
    auto q = BigInt(1);
    auto r = BigInt(0);
    auto t = q;
    auto k = q;
    auto n = BigInt(3);
    auto l = n;

    bool first = true;
    while (ndigits < 1_000) {
        if (4 * q + r - t < n * t) {
            write(n); ndigits++;
            if (ndigits % 70 == 0) writeln();
            if (first) { first = false; write('.'); }
            auto nr = 10 * (r - n * t);
            n = ((10 * (3 * q + r)) / t) - 10 * n;
            q *= 10;
            r = nr;
        } else {
            auto nr = (2    * q + r) * l;
            auto nn = (q * (7 * k + 2) + r * l) / (t * l);
            q *= k;
            t *= l;
            l += 2;
            k++;
            n = nn;
            r = nr;
        }
    }
}
