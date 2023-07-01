#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

bool isPrime(int64_t n) {
    int64_t i;

    if (n < 2)       return false;
    if (n % 2 == 0)  return n == 2;
    if (n % 3 == 0)  return n == 3;
    if (n % 5 == 0)  return n == 5;
    if (n % 7 == 0)  return n == 7;
    if (n % 11 == 0) return n == 11;
    if (n % 13 == 0) return n == 13;
    if (n % 17 == 0) return n == 17;
    if (n % 19 == 0) return n == 19;

    for (i = 23; i * i <= n; i += 2) {
        if (n % i == 0) return false;
    }

    return true;
}

int countTwinPrimes(int limit) {
    int count = 0;

    //       2          3          4
    int64_t p3 = true, p2 = true, p1 = false;
    int64_t i;

    for (i = 5; i <= limit; i++) {
        p3 = p2;
        p2 = p1;
        p1 = isPrime(i);
        if (p3 && p1) {
            count++;
        }
    }
    return count;
}

void test(int limit) {
    int count = countTwinPrimes(limit);
    printf("Number of twin prime pairs less than %d is %d\n", limit, count);
}

int main() {
    test(10);
    test(100);
    test(1000);
    test(10000);
    test(100000);
    test(1000000);
    test(10000000);
    test(100000000);
    return 0;
}
