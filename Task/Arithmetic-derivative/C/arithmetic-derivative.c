#include <stdio.h>
#include <stdint.h>

typedef uint64_t u64;

void primeFactors(u64 n, u64 *factors, int *length) {
    if (n < 2) return;
    int count = 0;
    int inc[8] = {4, 2, 4, 2, 4, 6, 2, 6};
    while (!(n%2)) {
        factors[count++] = 2;
        n /= 2;
    }
    while (!(n%3)) {
        factors[count++] = 3;
        n /= 3;
    }
    while (!(n%5)) {
        factors[count++] = 5;
        n /= 5;
    }
    for (u64 k = 7, i = 0; k*k <= n; ) {
        if (!(n%k)) {
            factors[count++] = k;
            n /= k;
        } else {
            k += inc[i];
            i = (i + 1) % 8;
        }
    }
    if (n > 1) {
        factors[count++] = n;
    }
    *length = count;
}

double D(double n) {
    if (n < 0) return -D(-n);
    if (n < 2) return 0;
    int i, length;
    double d;
    u64 f[80], g;
    if (n < 1e19) {
        primeFactors((u64)n, f, &length);
    } else {
        g = (u64)(n / 100);
        primeFactors(g, f, &length);
        f[length+1] = f[length] = 2;
        f[length+3] = f[length+2] = 5;
        length += 4;
    }
    if (length == 1) return 1;
    if (length == 2) return (double)(f[0] + f[1]);
    d = n / (double)f[0];
    return D(d) * (double)f[0] + d;
}

int main() {
    u64 ad[200];
    int n, m;
    double pow;
    for (n = -99; n < 101; ++n) {
        ad[n+99] = (int)D((double)n);
    }
    for (n = 0; n < 200; ++n) {
        printf("%4ld ", ad[n]);
        if (!((n+1)%10)) printf("\n");
    }
    printf("\n");
    pow = 1;
    for (m = 1; m < 21; ++m) {
        pow *= 10;
        printf("D(10^%-2d) / 7 = %.0f\n", m, D(pow)/7);
    }
    return 0;
}
