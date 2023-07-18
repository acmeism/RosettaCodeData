#include <stdio.h>
#include <stdbool.h>

bool is_substring(unsigned n, unsigned k) {
    unsigned startMatch = 0;

    for (unsigned pfx = k; n > 0; n /= 10) {
        if (pfx % 10 == n % 10) {
            pfx /= 10;
            if (startMatch == 0) startMatch = n;
        } else {
            pfx = k;
            if (startMatch != 0) n = startMatch;
            startMatch = 0;
        }

        if (pfx == 0) return true;
    }
    return false;
}

bool factors_are_substrings(unsigned n) {
    if (n%2==0 || n%3==0 || n%5==0 || n%7==0) return false;

    unsigned factor_count = 0;
    for (unsigned factor = 11, n_rest = n; factor <= n_rest; factor += 2) {
        if (n_rest % factor != 0) continue;
        while (n_rest % factor == 0) n_rest /= factor;
        if (!is_substring(n, factor)) return false;
        factor_count++;
    }
    return factor_count > 1;
}

int main(void) {
    unsigned amount = 10;
    for (unsigned n = 11; amount > 0; n += 2) {
        if (factors_are_substrings(n)) {
            printf("%u\n", n);
            amount--;
        }
    }
    return 0;
}
