#include <stdio.h>
#include <stdbool.h>
#include <locale.h>

bool isPrime(int n) {
    int d;
    if (n < 2)  return false;
    if (!(n%2)) return n == 2;
    if (!(n%3)) return n == 3;
    d = 5;
    while (d*d <= n) {
        if (!(n%d)) return false;
        d += 2;
        if (!(n%d)) return false;
        d += 4;
    }
    return true;
}

int main() {
    int n, p;
    const int limit = 200;
    setlocale(LC_ALL, "");
    for (n = 1; n < limit; ++n) {
        p = n*n*n + 2;
        if (isPrime(p)) {
            printf("n = %3d => n³ + 2 = %'9d\n", n, p);
        }
    }
    return 0;
}
