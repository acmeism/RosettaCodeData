#include <stdio.h>
#include <stdbool.h>

bool isIdoneal(int n) {
    int a, b, c, sum;
    for (a = 1; a < n; ++a) {
        for (b = a + 1; b < n; ++b) {
            if (a*b + a + b > n) break;
            for (c = b + 1; c < n; ++c) {
                sum = a*b + b*c + a*c;
                if (sum == n) return false;
                if (sum > n) break;
            }
        }
    }
    return true;
}

int main() {
    int n, count = 0;
    for (n = 1; n <= 1850; ++n) {
        if (isIdoneal(n)) {
            printf("%4d ", n);
            if (!(++count % 13)) printf("\n");
         }
    }
    return 0;
}
