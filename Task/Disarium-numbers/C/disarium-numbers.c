#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int power (int base, int exponent) {
    int result = 1;
    for (int i = 1; i <= exponent; i++) {
        result *= base;
    }
    return result;
}

int is_disarium (int num) {
    int n = num;
    int sum = 0;
    int len = n <= 9 ? 1 : floor(log10(n)) + 1;
    while (n > 0) {
        sum += power(n % 10, len);
        n /= 10;
        len--;
    }

    return num == sum;
}

int main() {
    int count = 0;
    int i = 0;
    while (count < 19) {
        if (is_disarium(i)) {
            printf("%d ", i);
            count++;
        }
        i++;
    }
    printf("%s\n", "\n");
}
