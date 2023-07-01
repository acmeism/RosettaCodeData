#include <stdio.h>

typedef char bool;

#define TRUE 1
#define FALSE 0

bool same_digits(int n, int b) {
    int f = n % b;
    n /= b;
    while (n > 0) {
        if (n % b != f) return FALSE;
        n /= b;
    }
    return TRUE;
}

bool is_brazilian(int n) {
    int b;
    if (n < 7) return FALSE;
    if (!(n % 2) && n >= 8) return TRUE;
    for (b = 2; b < n - 1; ++b) {
        if (same_digits(n, b)) return TRUE;
    }
    return FALSE;
}

bool is_prime(int n) {
    int d = 5;
    if (n < 2) return FALSE;
    if (!(n % 2)) return n == 2;
    if (!(n % 3)) return n == 3;
    while (d * d <= n) {
        if (!(n % d)) return FALSE;
        d += 2;
        if (!(n % d)) return FALSE;
        d += 4;
    }
    return TRUE;
}

int main() {
    int i, c, n;
    const char *kinds[3] = {" ", " odd ", " prime "};
    for (i = 0; i < 3; ++i) {
        printf("First 20%sBrazilian numbers:\n", kinds[i]);
        c = 0;
        n = 7;
        while (TRUE) {
            if (is_brazilian(n)) {
                printf("%d ", n);
                if (++c == 20) {
                    printf("\n\n");
                    break;
                }
            }
            switch (i) {
                case 0: n++; break;
                case 1: n += 2; break;
                case 2:
                    do {
                        n += 2;
                    } while (!is_prime(n));
                    break;
            }
        }
    }

    for (n = 7, c = 0; c < 100000; ++n) {
        if (is_brazilian(n)) c++;
    }
    printf("The 100,000th Brazilian number: %d\n", n - 1);
    return 0;
}
