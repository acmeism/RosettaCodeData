#include <stdio.h>
#include <string.h>

typedef int bool;
typedef unsigned long long ull;

#define TRUE 1
#define FALSE 0

/* OK for 'small' numbers. */
bool is_prime(ull n) {
    ull d;
    if (n < 2) return FALSE;
    if (!(n % 2)) return n == 2;
    if (!(n % 3)) return n == 3;
    d = 5;
    while (d * d <= n) {
        if (!(n % d)) return FALSE;
        d += 2;
        if (!(n % d)) return FALSE;
        d += 4;
    }
    return TRUE;
}

void ord(char *res, int n) {
    char suffix[3];
    int m = n % 100;
    if (m >= 4 && m <= 20) {
        sprintf(res,"%dth", n);
        return;
    }
    switch(m % 10) {
        case 1:
            strcpy(suffix, "st");
            break;
        case 2:
            strcpy(suffix, "nd");
            break;
        case 3:
            strcpy(suffix, "rd");
            break;
        default:
            strcpy(suffix, "th");
            break;
    }
    sprintf(res, "%d%s", n, suffix);
}

bool is_magnanimous(ull n) {
    ull p, q, r;
    if (n < 10) return TRUE;
    for (p = 10; ; p *= 10) {
        q = n / p;
        r = n % p;
        if (!is_prime(q + r)) return FALSE;
        if (q < 10) break;
    }
    return TRUE;
}

void list_mags(int from, int thru, int digs, int per_line) {
    ull i = 0;
    int c = 0;
    char res1[13], res2[13];
    if (from < 2) {
        printf("\nFirst %d magnanimous numbers:\n", thru);
    } else {
        ord(res1, from);
        ord(res2, thru);
        printf("\n%s through %s magnanimous numbers:\n", res1, res2);
    }
    for ( ; c < thru; ++i) {
        if (is_magnanimous(i)) {
            if (++c >= from) {
                printf("%*llu ", digs, i);
                if (!(c % per_line)) printf("\n");
            }
        }
    }
}

int main() {
    list_mags(1, 45, 3, 15);
    list_mags(241, 250, 1, 10);
    list_mags(391, 400, 1, 10);
    return 0;
}
