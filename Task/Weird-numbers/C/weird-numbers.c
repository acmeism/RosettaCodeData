#include "stdio.h"
#include "stdlib.h"
#include "stdbool.h"
#include "string.h"

struct int_a {
    int *ptr;
    size_t size;
};

struct int_a divisors(int n) {
    int *divs, *divs2, *out;
    int i, j, c1 = 0, c2 = 0;
    struct int_a array;

    divs = malloc(n * sizeof(int) / 2);
    divs2 = malloc(n * sizeof(int) / 2);
    divs[c1++] = 1;

    for (i = 2; i * i <= n; i++) {
        if (n % i == 0) {
            j = n / i;
            divs[c1++] = i;
            if (i != j) {
                divs2[c2++] = j;
            }
        }
    }

    out = malloc((c1 + c2) * sizeof(int));
    for (int i = 0; i < c2; i++) {
        out[i] = divs2[i];
    }
    for (int i = 0; i < c1; i++) {
        out[c2 + i] = divs[c1 - i - 1];
    }
    array.ptr = out;
    array.size = c1 + c2;

    free(divs);
    free(divs2);
    return array;
}

bool abundant(int n, struct int_a divs) {
    int sum = 0;
    int i;
    for (i = 0; i < divs.size; i++) {
        sum += divs.ptr[i];
    }
    return sum > n;
}

bool semiperfect(int n, struct int_a divs) {
    if (divs.size > 0) {
        int h = *divs.ptr;
        int *t = divs.ptr + 1;

        struct int_a ta;
        ta.ptr = t;
        ta.size = divs.size - 1;

        if (n < h) {
            return semiperfect(n, ta);
        } else {
            return n == h
                || semiperfect(n - h, ta)
                || semiperfect(n, ta);
        }
    } else {
        return false;
    }
}

bool *sieve(int limit) {
    bool *w = calloc(limit, sizeof(bool));
    struct int_a divs;
    int i, j;

    for (i = 2; i < limit; i += 2) {
        if (w[i]) continue;
        divs = divisors(i);
        if (!abundant(i, divs)) {
            w[i] = true;
        } else if (semiperfect(i, divs)) {
            for (j = i; j < limit; j += i) {
                w[j] = true;
            }
        }
    }

    free(divs.ptr);
    return w;
}

int main() {
    bool *w = sieve(17000);
    int count = 0;
    int max = 25;
    int n;

    printf("The first 25 weird numbers:\n");
    for (n = 2; count < max; n += 2) {
        if (!w[n]) {
            printf("%d ", n);
            count++;
        }
    }
    printf("\n");

    free(w);
    return 0;
}
