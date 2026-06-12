#include <stdio.h>
#include <math.h>

typedef unsigned long long ulong;

ulong root(ulong base, ulong n) {
    ulong n1, n2, n3, c, d, e;

    if (base < 2) return base;
    if (n == 0) return 1;

    n1 = n - 1;
    n2 = n;
    n3 = n1;
    c = 1;
    d = (n3 + base) / n2;
    e = (n3 * d + base / (ulong)powl(d, n1)) / n2;

    while (c != d && c != e) {
        c = d;
        d = e;
        e = (n3*e + base / (ulong)powl(e, n1)) / n2;
    }

    if (d < e) return d;
    return e;
}

int main() {
    ulong b = (ulong)2e18;

    printf("3rd root of 8 = %lld\n", root(8, 3));
    printf("3rd root of 9 = %lld\n", root(9, 3));
    printf("2nd root of %lld = %lld\n", b, root(b, 2));

    return 0;
}
