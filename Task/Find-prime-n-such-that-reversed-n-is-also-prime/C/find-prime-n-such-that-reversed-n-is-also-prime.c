#include <stdbool.h>
#include <stdio.h>

bool is_prime(unsigned int n) {
    if (n < 2)
        return false;
    if (n % 2 == 0)
        return n == 2;
    if (n % 3 == 0)
        return n == 3;
    for (unsigned int p = 5; p * p <= n; p += 4) {
        if (n % p == 0)
            return false;
        p += 2;
        if (n % p == 0)
            return false;
    }
    return true;
}

unsigned int reverse(unsigned int n) {
    unsigned int rev = 0;
    for (; n > 0; n /= 10)
        rev = rev * 10 + n % 10;
    return rev;
}

int main() {
    unsigned int count = 0;
    for (unsigned int n = 1; n < 500; ++n) {
        if (is_prime(n) && is_prime(reverse(n)))
            printf("%3u%c", n, ++count % 10 == 0 ? '\n' : ' ');
    }
    printf("\nCount = %u\n", count);
    return 0;
}
