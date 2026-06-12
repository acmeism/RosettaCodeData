#include <stdio.h>
#include <stdbool.h>

int digit_sum(int n) {
    int sum;
    for (sum = 0; n; n /= 10) sum += n % 10;
    return sum;
}

/* The numbers involved are tiny */
bool prime(int n) {
    if (n<4) return n>=2;
    for (int d=2; d*d <= n; d++)
        if (n%d == 0) return false;
    return true;
}

int main() {
    for (int i=1; i<100; i++)
        if (prime(digit_sum(i*i)) & prime(digit_sum(i*i*i)))
            printf("%d ", i);
    printf("\n");
    return 0;
}
