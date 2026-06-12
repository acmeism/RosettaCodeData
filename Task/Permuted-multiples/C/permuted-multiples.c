#include <stdio.h>
#include <stdbool.h>

/* Find the set of digits of N, expressed as a number
   where the N'th digit represents the amount of times
   that digit occurs. */
int digit_set(int n) {
    static const int powers[] = {
        1, 10, 100, 1000, 10000, 100000, 1000000, 10000000,
        100000000, 1000000000
    };

    int dset;
    for (dset = 0; n; n /= 10)
        dset += powers[n % 10];
    return dset;
}

/* See if for a given N, [1..6]*N all have the same digits */
bool is_permuted_multiple(int n) {
    int dset = digit_set(n);
    for (int mult = 2; mult <= 6; mult++)
        if (dset != digit_set(n * mult)) return false;
    return true;
}

/* Find the first matching number */
int main() {
    int n;
    for (n = 123; !is_permuted_multiple(n); n++);
    for (int mult = 1; mult <= 6; mult++)
        printf("%d * n = %d\n", mult, n*mult);
    return 0;
}
