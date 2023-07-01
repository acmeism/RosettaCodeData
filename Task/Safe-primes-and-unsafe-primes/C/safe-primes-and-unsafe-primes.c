#include <stdbool.h>
#include <stdio.h>

int primes[] = {
    2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97,
    101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199,
    211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331
};
#define PCOUNT (sizeof(primes) / sizeof(int))

bool isPrime(int n) {
    int i;

    if (n < 2) {
        return false;
    }

    for (i = 0; i < PCOUNT; i++) {
        if (n == primes[i]) {
            return true;
        }
        if (n % primes[i] == 0) {
            return false;
        }
        if (n < primes[i] * primes[i]) {
            return true;
        }
    }

    for (i = primes[PCOUNT - 1] + 2; i * i <= n; i += 2) {
        if (n % i == 0) {
            return false;
        }
    }

    return true;
}

int main() {
    int beg, end;
    int i, count;

    // safe primes
    ///////////////////////////////////////////
    beg = 2;
    end = 1000000;
    count = 0;
    printf("First 35 safe primes:\n");
    for (i = beg; i < end; i++) {
        if (isPrime(i) && isPrime((i - 1) / 2)) {
            if (count < 35) {
                printf("%d ", i);
            }
            count++;
        }
    }
    printf("\nThere are  %d safe primes below  %d\n", count, end);

    beg = end;
    end = end * 10;
    for (i = beg; i < end; i++) {
        if (isPrime(i) && isPrime((i - 1) / 2)) {
            count++;
        }
    }
    printf("There are %d safe primes below %d\n", count, end);

    // unsafe primes
    ///////////////////////////////////////////
    beg = 2;
    end = 1000000;
    count = 0;
    printf("\nFirst 40 unsafe primes:\n");
    for (i = beg; i < end; i++) {
        if (isPrime(i) && !isPrime((i - 1) / 2)) {
            if (count < 40) {
                printf("%d ", i);
            }
            count++;
        }
    }
    printf("\nThere are  %d unsafe primes below  %d\n", count, end);

    beg = end;
    end = end * 10;
    for (i = beg; i < end; i++) {
        if (isPrime(i) && !isPrime((i - 1) / 2)) {
            count++;
        }
    }
    printf("There are %d unsafe primes below %d\n", count, end);

    return 0;
}
