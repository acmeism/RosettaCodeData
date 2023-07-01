import std.stdio;

int chowla(int n) {
    int sum;
    for (int i = 2, j; i * i <= n; ++i) {
        if (n % i == 0) {
            sum += i + (i == (j = n / i) ? 0 : j);
        }
    }
    return sum;
}

bool[] sieve(int limit) {
    // True denotes composite, false denotes prime.
    // Only interested in odd numbers >= 3
    auto c = new bool[limit];
    for (int i = 3; i * 3 < limit; i += 2) {
        if (!c[i] && (chowla(i) == 0)) {
            for (int j = 3 * i; j < limit; j += 2 * i) {
                c[j] = true;
            }
        }
    }
    return c;
}

void main() {
    foreach (i; 1..38) {
        writefln("chowla(%d) = %d", i, chowla(i));
    }
    int count = 1;
    int limit = cast(int)1e7;
    int power = 100;
    bool[] c = sieve(limit);
    for (int i = 3; i < limit; i += 2) {
        if (!c[i]) {
            count++;
        }
        if (i == power - 1) {
            writefln("Count of primes up to %10d = %d", power, count);
            power *= 10;
        }
    }

    count = 0;
    limit = 350_000_000;
    int k = 2;
    int kk = 3;
    int p;
    for (int i = 2; ; ++i) {
        p = k * kk;
        if (p > limit) {
            break;
        }
        if (chowla(p) == p - 1) {
            writefln("%10d is a number that is perfect", p);
            count++;
        }
        k = kk + 1;
        kk += k;
    }
    writefln("There are %d perfect numbers <= 35,000,000", count);
}
