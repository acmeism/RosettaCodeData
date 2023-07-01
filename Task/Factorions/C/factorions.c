#include <stdio.h>

int main() {
    int n, b, d;
    unsigned long long i, j, sum, fact[12];
    // cache factorials from 0 to 11
    fact[0] = 1;
    for (n = 1; n < 12; ++n) {
        fact[n] = fact[n-1] * n;
    }

    for (b = 9; b <= 12; ++b) {
        printf("The factorions for base %d are:\n", b);
        for (i = 1; i < 1500000; ++i) {
            sum = 0;
            j = i;
            while (j > 0) {
                d = j % b;
                sum += fact[d];
                j /= b;
            }
            if (sum == i) printf("%llu ", i);
        }
        printf("\n\n");
    }
    return 0;
}
