#include <stdio.h>

#define MAX 15

int count_divisors(int n) {
    int i, count = 0;
    for (i = 1; i * i <= n; ++i) {
        if (!(n % i)) {
            if (i == n / i)
                count++;
            else
                count += 2;
        }
    }
    return count;
}

int main() {
    int i, k, n, seq[MAX];
    for (i = 0; i < MAX; ++i) seq[i] = 0;
    printf("The first %d terms of the sequence are:\n", MAX);
    for (i = 1, n = 0; n <  MAX; ++i) {
        k = count_divisors(i);
        if (k <= MAX && seq[k - 1] == 0) {
            seq[k - 1] = i;
            ++n;
        }
    }
    for (i = 0; i < MAX; ++i) printf("%d ", seq[i]);
    printf("\n");
    return 0;
}
