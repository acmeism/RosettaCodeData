#include <stdio.h>
#include <limits.h>
#include <stdlib.h>
#include <time.h>

// Get size of statically allocated array
#define ARR_LEN(ARR) (sizeof ARR / sizeof *ARR)
// Generate random number in the interval [M,N]
#define RAND_RNG(M,N) (M + rand() / (RAND_MAX / (N - M + 1) + 1));

void radix_sort(const size_t n, int *array) {
    int *nums = (int*)malloc(2*n*sizeof(int));
    for (size_t ibit=0; ibit<8*sizeof(int)-1; ibit++) {
        size_t nnums[2] = {0, 0};
        for (size_t i=0; i<n; i++) {
            int bit = (array[i]>>ibit)&0b1;
            nums[bit*n+nnums[bit]] = array[i];
            nnums[bit]++;
        }
        // To make it easily extendable to more buckets
        size_t offset = 0;
        for (int ibuck=0; ibuck<2; ibuck++) {
            for (size_t i=0; i<nnums[ibuck]; i++) {
              array[i+offset] = nums[ibuck*n+i];
            }
            offset += nnums[ibuck];
        }
    }
    {
        // Sign bit needs reverse sorting due to twos complement
        int ibit = 8*sizeof(int)-1;
        size_t nnums[2] = {0, 0};
        for (size_t i=0; i<n; i++) {
            int bit = (array[i]>>ibit)&0b1;
            nums[bit*n+nnums[bit]] = array[i];
            nnums[bit]++;
        }
        // To make it easily extendable to more buckets
        size_t offset = 0;
        for (int ibuck=1; ibuck<2; ibuck++) {
            for (size_t i=0; i<nnums[ibuck]; i++) {
              array[i+offset] = nums[ibuck*n+i];
            }
            offset += nnums[ibuck];
        }
        for (int ibuck=0; ibuck<1; ibuck++) {
            for (size_t i=0; i<nnums[ibuck]; i++) {
              array[i+offset] = nums[ibuck*n+i];
            }
            offset += nnums[ibuck];
        }
    }
    free(nums);
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
