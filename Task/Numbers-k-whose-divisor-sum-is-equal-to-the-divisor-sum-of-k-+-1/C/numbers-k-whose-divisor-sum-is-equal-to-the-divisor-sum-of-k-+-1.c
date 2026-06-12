#include <stdio.h>
#include <locale.h>

int divisorSum(int n) {
    int i = 3, total = 1, power = 2, sum;
    while (!(n % 2)) {
        total += power;
        power <<= 1;
        n >>= 1;
    }
    while (i * i <= n) {
        sum = 1;
        power = i;
        while (!(n % i)) {
            sum += power;
            power *= i;
            n /= i;
        }
        total *= sum;
        i += 2;
    }
    if (n > 1) total *= n + 1;
    return total;
}

int main() {
    const int n = 50;
    int res[n];
    int i = 2, c = 0, prevSum = 1, currSum;
    while (c < n) {
        currSum = divisorSum(i);
        if (prevSum == currSum) res[c++] = i - 1;
        prevSum = currSum;
        i++;
    }
    setlocale(LC_NUMERIC, "en_US.UTF-8");
    for (c = 0; c < n; ++c) {
        printf("%'7d ", res[c]);
        if (!(c + 1)%10) printf("\n");
    }
    return 0;
}
