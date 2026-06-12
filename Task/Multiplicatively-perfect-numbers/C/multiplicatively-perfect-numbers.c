#include <stdio.h>
#include <stdbool.h>
#include <locale.h>

bool isPrime(int n) {
    if (n < 2) return false;
    if (n%2 == 0) return n == 2;
    if (n%3 == 0) return n == 3;
    int d = 5;
    while (d*d <= n) {
        if (n%d == 0) return false;
        d += 2;
        if (n%d == 0) return false;
        d += 4;
    }
    return true;
}

void divisors(int n, int *divs, int *length) {
    int i, j, k = 1, c = 0;
    if (n%2) k = 2;
    for (i = 1; i*i <= n; i += k) {
        if (i == 1) continue; // exclude 1 and n
        if (!(n%i)) {
            divs[c++] = i;
            if (c > 2) break; // not eligible if has > 2 divisors
            j = n / i;
            if (j != i) divs[c++] = j;
        }
    }
    *length = c;
}

int main() {
    int i, d, j, k, t, length, prod;
    int divs[4], count = 0, limit = 500, s = 3, c = 3, squares = 1, cubes = 1;
    printf("Multiplicatively perfect numbers under %d:\n", limit);
    setlocale(LC_NUMERIC, "");
    for (i = 1; ; ++i) {
        if (i != 1) {
            divisors(i, divs, &length);
        } else {
            divs[1] = divs[0] = 1;
            length = 2;
        }
        if (length == 2 && divs[0] * divs[1] == i) {
            ++count;
            if (i < 500) {
                printf("%3d  ", i);
                if (!(count%10)) printf("\n");
            }
        }
        if (i == 499) printf("\n");
        if (i >= limit - 1) {
            for (j = s; j * j < limit; j += 2) if (isPrime(j)) ++squares;
            for (k = c; k * k * k < limit; k +=2 ) if (isPrime(k)) ++cubes;
            t = count + squares - cubes - 1;
            printf("Counts under %'9d: MPNs = %'7d  Semi-primes = %'7d\n", limit, count, t);
            if (limit == 5000000) break;
            s = j;
            c = k;
            limit *= 10;
        }
    }
    return 0;
}
