import std.stdio;

int totient(int n) {
    int tot = n;

    for (int i = 2; i * i <= n; i += 2) {
        if (n % i == 0) {
            while (n % i == 0) {
                n /= i;
            }
            tot -= tot / i;
        }
        if (i==2) {
            i = 1;
        }
    }

    if (n > 1) {
        tot -= tot / n;
    }
    return tot;
}

void main() {
    writeln(" n    φ   prime");
    writeln("---------------");

    int count = 0;
    for (int n = 1; n <= 25; n++) {
        int tot = totient(n);

        if (n - 1 == tot) {
            count++;
        }

        writefln("%2d   %2d   %s", n,tot, n - 1 == tot);
    }
    writeln;

    writefln("Number of primes up to %6d = %4d", 25, count);
    for (int n = 26; n <= 100_000; n++) {
        int tot = totient(n);

        if (n - 1 == tot) {
            count++;
        }

        if (n == 100 || n == 1_000 || n % 10_000 == 0) {
            writefln("Number of primes up to %6d = %4d", n, count);
        }
    }
}
