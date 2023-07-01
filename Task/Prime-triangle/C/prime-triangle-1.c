#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <time.h>

bool is_prime(unsigned int n) {
    assert(n < 64);
    static bool isprime[] = {0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0,
                             0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1,
                             0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1,
                             0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0};
    return isprime[n];
}

void swap(unsigned int* a, size_t i, size_t j) {
    unsigned int tmp = a[i];
    a[i] = a[j];
    a[j] = tmp;
}

bool prime_triangle_row(unsigned int* a, size_t length) {
    if (length == 2)
        return is_prime(a[0] + a[1]);
    for (size_t i = 1; i + 1 < length; i += 2) {
        if (is_prime(a[0] + a[i])) {
            swap(a, i, 1);
            if (prime_triangle_row(a + 1, length - 1))
                return true;
            swap(a, i, 1);
        }
    }
    return false;
}

int prime_triangle_count(unsigned int* a, size_t length) {
    int count = 0;
    if (length == 2) {
        if (is_prime(a[0] + a[1]))
            ++count;
    } else {
        for (size_t i = 1; i + 1 < length; i += 2) {
            if (is_prime(a[0] + a[i])) {
                swap(a, i, 1);
                count += prime_triangle_count(a + 1, length - 1);
                swap(a, i, 1);
            }
        }
    }
    return count;
}

void print(unsigned int* a, size_t length) {
    if (length == 0)
        return;
    printf("%2u", a[0]);
    for (size_t i = 1; i < length; ++i)
        printf(" %2u", a[i]);
    printf("\n");
}

int main() {
    clock_t start = clock();
    for (unsigned int n = 2; n < 21; ++n) {
        unsigned int a[n];
        for (unsigned int i = 0; i < n; ++i)
            a[i] = i + 1;
        if (prime_triangle_row(a, n))
            print(a, n);
    }
    printf("\n");
    for (unsigned int n = 2; n < 21; ++n) {
        unsigned int a[n];
        for (unsigned int i = 0; i < n; ++i)
            a[i] = i + 1;
        if (n > 2)
            printf(" ");
        printf("%d", prime_triangle_count(a, n));
    }
    printf("\n");
    clock_t end = clock();
    double duration = (end - start + 0.0) / CLOCKS_PER_SEC;
    printf("\nElapsed time: %f seconds\n", duration);
    return 0;
}
