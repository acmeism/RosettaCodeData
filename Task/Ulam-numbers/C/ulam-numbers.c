#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

void fatal(const char* message) {
    fprintf(stderr, "%s\n", message);
    exit(1);
}

void* xmalloc(size_t n) {
    void* ptr = malloc(n);
    if (ptr == NULL)
        fatal("Out of memory");
    return ptr;
}

void* xrealloc(void* p, size_t n) {
    void* ptr = realloc(p, n);
    if (ptr == NULL)
        fatal("Out of memory");
    return ptr;
}

int* extend(int* array, int min_length, int* capacity) {
    int new_capacity = *capacity;
    if (new_capacity >= min_length)
        return array;
    while (new_capacity < min_length)
        new_capacity *= 2;
    array = xrealloc(array, new_capacity * sizeof(int));
    memset(array + *capacity, 0, (new_capacity - *capacity) * sizeof(int));
    *capacity = new_capacity;
    return array;
}

int ulam(int n) {
    int* ulams = xmalloc((n < 2 ? 2 : n) * sizeof(int));
    ulams[0] = 1;
    ulams[1] = 2;
    int sieve_length = 2;
    int sieve_capacity = 2;
    int* sieve = xmalloc(sieve_capacity * sizeof(int));
    sieve[0] = sieve[1] = 1;
    for (int u = 2, ulen = 2; ulen < n; ) {
        sieve_length = u + ulams[ulen - 2];
        sieve = extend(sieve, sieve_length, &sieve_capacity);
        for (int i = 0; i < ulen - 1; ++i)
            ++sieve[u + ulams[i] - 1];
        for (int i = u; i < sieve_length; ++i) {
            if (sieve[i] == 1) {
                u = i + 1;
                ulams[ulen++] = u;
                break;
            }
        }
    }
    int result = ulams[n - 1];
    free(ulams);
    free(sieve);
    return result;
}

int main() {
    clock_t start = clock();
    for (int n = 1; n <= 100000; n *= 10)
        printf("Ulam(%d) = %d\n", n, ulam(n));
    clock_t finish = clock();
    printf("Elapsed time: %.3f seconds\n", (finish - start + 0.0)/CLOCKS_PER_SEC);
    return 0;
}
