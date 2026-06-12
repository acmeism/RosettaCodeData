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

int main() {
    int i, j, n, pows2[20], dp[50], dpc = 1, dp1000, dp10000, count, pow;
    bool found;
    for (i = 0; i < 20; ++i) pows2[i] = 1 << i;
    dp[0] = 1;
    for (n = 3, count = 1; count < 10000; n += 2) {
        found = false;
        for (j = 0; j < 20; ++j) {
            pow = pows2[j];
            if (pow > n) break;
            if (isPrime(n-pow)) {
                found = true;
                break;
            }
        }
        if (!found) {
            ++count;
            if (count <= 50) {
                dp[dpc++] = n;
            } else if (count == 1000) {
                dp1000 = n;
            } else if (count == 10000) {
                dp10000 = n;
            }
        }
    }
    setlocale(LC_NUMERIC, "");
    printf("First 50 De Polignac numbers:\n");
    for (i = 0; i < dpc; ++i) {
        printf("%'5d ", dp[i]);
        if (!((i+1)%10)) printf("\n");
    }
    printf("\nOne thousandth: %'d\n", dp1000);
    printf("\nTen thousandth: %'d\n", dp10000);
    return 0;
}
