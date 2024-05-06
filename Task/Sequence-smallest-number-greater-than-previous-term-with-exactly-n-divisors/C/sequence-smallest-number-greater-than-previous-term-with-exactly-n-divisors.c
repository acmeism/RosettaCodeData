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
    int i, next = 1;
    printf("The first %d terms of the sequence are:\n", MAX);
    for (i = 1; next <= MAX; ++i) {
        if (next == count_divisors(i)) {
            printf("%d ", i);
            next++;
        }
    }
    printf("\n");
    return 0;
}
