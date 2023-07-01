#include <stdio.h>
#include <locale.h>

#define LIMIT 42

int is_prime(long long n) {
    if (n % 2 == 0) return n == 2;
    if (n % 3 == 0) return n == 3;
    long long d = 5;
    while (d * d <= n) {
        if (n % d == 0) return 0;
        d += 2;
        if (n % d == 0) return 0;
        d += 4;
    }
    return 1;
}

int main() {
    long long i;
    int n;
    setlocale(LC_NUMERIC, "");
    for (i = LIMIT, n = 0; n < LIMIT; i++)
        if (is_prime(i)) {
            n++;
            printf("n = %-2d  %'19lld\n", n, i);
            i += i - 1;
        }
    return 0;
}
