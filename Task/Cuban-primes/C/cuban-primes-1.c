#include <limits.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

typedef long long llong_t;
struct PrimeArray {
    llong_t *ptr;
    size_t size;
    size_t capacity;
};

struct PrimeArray allocate() {
    struct PrimeArray primes;

    primes.size = 0;
    primes.capacity = 10;
    primes.ptr = malloc(primes.capacity * sizeof(llong_t));

    return primes;
}

void deallocate(struct PrimeArray *primes) {
    free(primes->ptr);
    primes->ptr = NULL;
}

void push_back(struct PrimeArray *primes, llong_t p) {
    if (primes->size >= primes->capacity) {
        size_t new_capacity = (3 * primes->capacity) / 2 + 1;
        llong_t *temp = realloc(primes->ptr, new_capacity * sizeof(llong_t));
        if (NULL == temp) {
            fprintf(stderr, "Failed to reallocate the prime array.");
            exit(1);
        } else {
            primes->ptr = temp;
            primes->capacity = new_capacity;
        }
    }

    primes->ptr[primes->size++] = p;
}

int main() {
    const int cutOff = 200, bigUn = 100000, chunks = 50, little = bigUn / chunks;
    struct PrimeArray primes = allocate();
    int c = 0;
    bool showEach = true;
    llong_t u = 0, v = 1, i;

    push_back(&primes, 3);
    push_back(&primes, 5);

    printf("The first %d cuban primes:\n", cutOff);
    for (i = 1; i < LLONG_MAX; ++i) {
        bool found = false;
        llong_t mx = ceil(sqrt(v += (u += 6)));
        llong_t j;

        for (j = 0; j < primes.size; ++j) {
            if (primes.ptr[j] > mx) {
                break;
            }
            if (v % primes.ptr[j] == 0) {
                found = true;
                break;
            }
        }
        if (!found) {
            c += 1;
            if (showEach) {
                llong_t z;
                for (z = primes.ptr[primes.size - 1] + 2; z <= v - 2; z += 2) {
                    bool fnd = false;

                    for (j = 0; j < primes.size; ++j) {
                        if (primes.ptr[j] > mx) {
                            break;
                        }
                        if (z % primes.ptr[j] == 0) {
                            fnd = true;
                            break;
                        }
                    }
                    if (!fnd) {
                        push_back(&primes, z);
                    }
                }
                push_back(&primes, v);
                printf("%11lld", v);
                if (c % 10 == 0) {
                    printf("\n");
                }
                if (c == cutOff) {
                    showEach = false;
                    printf("\nProgress to the %dth cuban prime: ", bigUn);
                }
            }
            if (c % little == 0) {
                printf(".");
                if (c == bigUn) {
                    break;
                }
            }
        }
    }
    printf("\nThe %dth cuban prime is %lld\n", c, v);

    deallocate(&primes);
    return 0;
}
