#include <stdbool.h>
#include <stdio.h>

bool isPrime(int n) {
    if (n < 0) {
        n = -n;
    }
    return n == 2 || n == 3 || n == 5 || n == 7;
}

int main() {
    int count = 0;
    int i, j;
    int d[3];
    int dptr;

    printf("Strange numbers in the open interval (100, 500) are:\n");
    for (i = 101; i < 500; i++) {
        dptr = 0;
        j = i;
        while (j > 0) {
            d[dptr++] = j % 10;
            j /= 10;
        }
        if (isPrime(d[0] - d[1]) && isPrime(d[1] - d[2])) {
            printf("%d ", i);
            count++;
            if (count % 10 == 0) {
                printf("\n");
            }
        }
    }
    if (count % 10 != 0) {
        printf("\n");
    }
    printf("\n%d strange numbers in all.\n", count);

    return 0;
}
