#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

int numPrimeFactors(unsigned x) {
    unsigned p = 2;
    int pf = 0;
    if (x == 1)
        return 1;
    else {
        while (true) {
            if (!(x % p)) {
                pf++;
                x /= p;
                if (x == 1)
                    return pf;
            }
            else
                ++p;
        }
    }
}

void primeFactors(unsigned x, unsigned* arr) {
    unsigned p = 2;
    int pf = 0;
    if (x == 1)
        arr[pf] = 1;
    else {
        while (true) {
            if (!(x % p)) {
                arr[pf++] = p;
                x /= p;
                if (x == 1)
                    return;
            }
            else
                p++;
        }
    }
}

unsigned sumDigits(unsigned x) {
    unsigned sum = 0, y;
    while (x) {
        y = x % 10;
        sum += y;
        x /= 10;
    }
    return sum;
}

unsigned sumFactors(unsigned* arr, int size) {
    unsigned sum = 0;
    for (int a = 0; a < size; a++)
        sum += sumDigits(arr[a]);
    return sum;
}

void listAllSmithNumbers(unsigned x) {
    unsigned *arr;
    for (unsigned a = 4; a < x; a++) {
        int numfactors = numPrimeFactors(a);
        arr = (unsigned*)malloc(numfactors * sizeof(unsigned));
        if (numfactors < 2)
            continue;	
        primeFactors(a, arr);	
        if (sumDigits(a) == sumFactors(arr,numfactors))
            printf("%4u ",a);
        free(arr);
    }
}

int main(int argc, char* argv[]) {
    printf("All the Smith Numbers < 10000 are:\n");
    listAllSmithNumbers(10000);
    return 0;
}
