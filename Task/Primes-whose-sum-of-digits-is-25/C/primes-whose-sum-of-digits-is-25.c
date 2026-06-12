#include <stdbool.h>
#include <stdio.h>

bool is_prime(int n) {
    int i = 5;

    if (n < 2) {
        return false;
    }
    if (n % 2 == 0) {
        return n == 2;
    }
    if (n % 3 == 0) {
        return n == 3;
    }

    while (i * i <= n) {
        if (n % i == 0) {
            return false;
        }
        i += 2;

        if (n % i == 0) {
            return false;
        }
        i += 4;
    }

    return true;
}

int digit_sum(int n) {
    int sum = 0;
    while (n > 0) {
        int rem = n % 10;
        n /= 10;
        sum += rem;
    }
    return sum;
}

int main() {
    int n;

    for (n = 2; n < 5000; n++) {
        if (is_prime(n) && digit_sum(n) == 25) {
            printf("%d ", n);
        }
    }

    return 0;
}
