import core.stdc.stdio: printf, putchar;

void farey(in uint n) nothrow @nogc {
    static struct Frac { uint d, n; }

    Frac f1 = { 0, 1 }, f2 = { 1, n };

    printf("%u/%u %u/%u", 0, 1, 1, n);
    while (f2.n > 1) {
        immutable k = (n + f1.n) / f2.n;
        immutable aux = f1;
        f1 = f2;
        f2 = Frac(f2.d * k - aux.d, f2.n * k - aux.n);
        printf(" %u/%u", f2.d, f2.n);
    }

    putchar('\n');
}

ulong fareyLength(in uint n, ref ulong[] cache) pure nothrow @safe {
    if (n >= cache.length) {
        auto newLen = cache.length;
        if (newLen == 0)
            newLen = 16;
        while (newLen <= n)
            newLen *= 2;
        cache.length = newLen;
    } else if (cache[n])
        return cache[n];

    ulong len = ulong(n) * (n + 3) / 2;
    for (uint p = 2, q = 0; p <= n; p = q) {
        q = n / (n / p) + 1;
        len -= fareyLength(n / p, cache) * (q - p);
    }

    cache[n] = len;
    return len;
}

void main() nothrow {
    foreach (immutable uint n; 1 .. 12) {
        printf("%u: ", n);
        n.farey;
    }

    ulong[] cache;
    for (uint n = 100; n <= 1_000; n += 100)
        printf("%u: %llu items\n", n, fareyLength(n, cache));

    immutable uint n = 10_000_000;
    printf("\n%u: %llu items\n", n, fareyLength(n, cache));
}
