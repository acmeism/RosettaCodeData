#include <iostream>

bool is_prime(int n) {
    if (n < 2) {
        return false;
    }

    if (n % 2 == 0) {
        return n == 2;
    }
    if (n % 3 == 0) {
        return n == 3;
    }

    int i = 5;
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

int main() {
    const int start = 1;
    const int stop = 1000;

    int sum = 0;
    int count = 0;
    int sc = 0;

    for (int p = start; p < stop; p++) {
        if (is_prime(p)) {
            count++;
            sum += p;
            if (is_prime(sum)) {
                printf("The sum of %3d primes in [2, %3d] is %5d which is also prime\n", count, p, sum);
                sc++;
            }
        }
    }
    printf("There are %d summerized primes in [%d, %d)\n", sc, start, stop);

    return 0;
}
