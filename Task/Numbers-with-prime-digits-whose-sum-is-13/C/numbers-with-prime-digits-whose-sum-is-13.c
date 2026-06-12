#include <stdbool.h>
#include <stdio.h>

bool primeDigitsSum13(int n) {
    int sum = 0;
    while (n > 0) {
        int r = n % 10;
        switch (r) {
        case 2:
        case 3:
        case 5:
        case 7:
            break;
        default:
            return false;
        }
        n /= 10;
        sum += r;
    }
    return sum == 13;
}

int main() {
    int i, c;

    // using 2 for all digits, 6 digits is the max prior to over-shooting 13
    c = 0;
    for (i = 1; i < 1000000; i++) {
        if (primeDigitsSum13(i)) {
            printf("%6d ", i);
            if (c++ == 10) {
                c = 0;
                printf("\n");
            }
        }
    }
    printf("\n");

    return 0;
}
