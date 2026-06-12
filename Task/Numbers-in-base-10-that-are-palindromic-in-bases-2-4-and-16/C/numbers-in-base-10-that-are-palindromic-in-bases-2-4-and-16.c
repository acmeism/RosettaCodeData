#include <stdio.h>
#define MAXIMUM 25000

int reverse(int n, int base) {
    int r;
    for (r = 0; n; n /= base)
        r = r*base + n%base;
    return r;
}

int palindrome(int n, int base) {
    return n == reverse(n, base);
}

int main() {
    int i, c = 0;

    for (i = 0; i < MAXIMUM; i++) {
        if (palindrome(i, 2) &&
            palindrome(i, 4) &&
            palindrome(i, 16)) {
            printf("%5d%c", i, ++c % 12 ? ' ' : '\n');
        }
    }
    printf("\n");
    return 0;
}
