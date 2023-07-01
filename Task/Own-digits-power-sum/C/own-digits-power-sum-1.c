#include <stdio.h>
#include <math.h>

#define MAX_DIGITS 9

int digits[MAX_DIGITS];

void getDigits(int i) {
    int ix = 0;
    while (i > 0) {
        digits[ix++] = i % 10;
        i /= 10;
    }
}

int main() {
    int n, d, i, max, lastDigit, sum, dp;
    int powers[10] = {0, 1, 4, 9, 16, 25, 36, 49, 64, 81};
    printf("Own digits power sums for N = 3 to 9 inclusive:\n");
    for (n = 3; n < 10; ++n) {
        for (d = 2; d < 10; ++d) powers[d] *= d;
        i = (int)pow(10, n-1);
        max = i * 10;
        lastDigit = 0;
        while (i < max) {
            if (!lastDigit) {
                getDigits(i);
                sum = 0;
                for (d = 0; d < n; ++d) {
                    dp = digits[d];
                    sum += powers[dp];
                }
            } else if (lastDigit == 1) {
                sum++;
            } else {
                sum += powers[lastDigit] - powers[lastDigit-1];
            }
            if (sum == i) {
                printf("%d\n", i);
                if (lastDigit == 0) printf("%d\n", i + 1);
                i += 10 - lastDigit;
                lastDigit = 0;
            } else if (sum > i) {
                i += 10 - lastDigit;
                lastDigit = 0;
            } else if (lastDigit < 9) {
                i++;
                lastDigit++;
            } else {
                i++;
                lastDigit = 0;
            }
        }
    }
    return 0;
}
