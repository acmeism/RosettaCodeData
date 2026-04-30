#include <stdio.h>
#include <stdio.h>
#include <limits.h>
#include <stdlib.h>
#include <time.h>

// Get size of statically allocated array
#define ARR_LEN(ARR) (sizeof ARR / sizeof *ARR)
// Generate random number in the interval [M,N]
#define RAND_RNG(M,N) (M + rand() / (RAND_MAX / (N - M + 1) + 1));

void radix_sort(const size_t n, int *array) {
    int *bit0_nums = (int*)malloc(n*sizeof(int));
    int *bit1_nums = (int*)malloc(n*sizeof(int));
    for (size_t ibit=0; ibit<8*sizeof(int)-1; ibit++) {
        size_t nbit0 = 0;
        size_t nbit1 = 0;
        for (size_t i=0; i<n; i++) {
            int bit = (array[i]>>ibit)&0b1;
            if (bit == 1) {
                bit1_nums[nbit1] = array[i];
                nbit1++;
            } else {
                bit0_nums[nbit0] = array[i];
                nbit0++;
            }
        }
        for (size_t i=0; i<nbit0; i++) {
            array[i] = bit0_nums[i];
        }
        for (size_t i=0; i<nbit1; i++) {
            array[i+nbit0] = bit1_nums[i];
        }
    }
    {
        // Sign bit needs reverse sorting due to twos complement
        int ibit = 8*sizeof(int)-1;
        size_t nbit0 = 0;
        size_t nbit1 = 0;
        for (size_t i=0; i<n; i++) {
            int bit = (array[i]>>ibit)&0b1;
            if (bit == 1) {
                bit1_nums[nbit1] = array[i];
                nbit1++;
            } else {
                bit0_nums[nbit0] = array[i];
                nbit0++;
            }
        }
        for (size_t i=0; i<nbit1; i++) {
            array[i] = bit1_nums[i];
        }
        for (size_t i=0; i<nbit0; i++) {
            array[i+nbit1] = bit0_nums[i];
        }
    }
    free(bit0_nums);
    free(bit1_nums);
}

int main(void) {
    srand(time(NULL));
    int x[16];

     for (size_t i = 0; i < ARR_LEN(x); i++) {
        x[i] = RAND_RNG(-128,127)
    }

    radix_sort(ARR_LEN(x), x);

    for (size_t i = 0; i < ARR_LEN(x); i++) {
        printf("%d%c", x[i], i + 1 < ARR_LEN(x) ? ' ' : '\n');
    }
}
