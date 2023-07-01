#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct stirling_cache_tag {
    int max;
    int* values;
} stirling_cache;

int stirling_number2(stirling_cache* sc, int n, int k) {
    if (k == n)
        return 1;
    if (k == 0 || k > n || n > sc->max)
        return 0;
    return sc->values[n*(n-1)/2 + k - 1];
}

bool stirling_cache_create(stirling_cache* sc, int max) {
    int* values = calloc(max * (max + 1)/2, sizeof(int));
    if (values == NULL)
        return false;
    sc->max = max;
    sc->values = values;
    for (int n = 1; n <= max; ++n) {
        for (int k = 1; k < n; ++k) {
            int s1 = stirling_number2(sc, n - 1, k - 1);
            int s2 = stirling_number2(sc, n - 1, k);
            values[n*(n-1)/2 + k - 1] = s1 + s2 * k;
        }
    }
    return true;
}

void stirling_cache_destroy(stirling_cache* sc) {
    free(sc->values);
    sc->values = NULL;
}

void print_stirling_numbers(stirling_cache* sc, int max) {
    printf("Stirling numbers of the second kind:\nn/k");
    for (int k = 0; k <= max; ++k)
        printf(k == 0 ? "%2d" : "%8d", k);
    printf("\n");
    for (int n = 0; n <= max; ++n) {
        printf("%2d ", n);
        for (int k = 0; k <= n; ++k)
            printf(k == 0 ? "%2d" : "%8d", stirling_number2(sc, n, k));
        printf("\n");
    }
}

int main() {
    stirling_cache sc = { 0 };
    const int max = 12;
    if (!stirling_cache_create(&sc, max)) {
        fprintf(stderr, "Out of memory\n");
        return 1;
    }
    print_stirling_numbers(&sc, max);
    stirling_cache_destroy(&sc);
    return 0;
}
