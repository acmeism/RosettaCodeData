#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <gmp.h>

void* xmalloc(size_t n) {
    void* ptr = malloc(n);
    if (ptr == NULL) {
        fprintf(stderr, "Out of memory\n");
        exit(1);
    }
    return ptr;
}

void* xrealloc(void* p, size_t n) {
    void* ptr = realloc(p, n);
    if (ptr == NULL) {
        fprintf(stderr, "Out of memory\n");
        exit(1);
    }
    return ptr;
}

bool is_prime(uint32_t n) {
    if (n == 2)
        return true;
    if (n < 2 || n % 2 == 0)
        return false;
    for (uint32_t p = 3; p * p <= n; p += 2) {
        if (n % p == 0)
            return false;
    }
    return true;
}

// Populates primes with the prime numbers between from and to and
// returns the number of primes found.
uint32_t find_primes(uint32_t from, uint32_t to, uint32_t** primes) {
    uint32_t count = 0, buffer_length = 16;
    uint32_t* buffer = xmalloc(sizeof(uint32_t) * buffer_length);
    for (uint32_t p = from; p <= to; ++p) {
        if (is_prime(p)) {
            if (count >= buffer_length) {
                uint32_t new_length = buffer_length * 2;
                if (new_length < count + 1)
                    new_length = count + 1;
                buffer = xrealloc(buffer, sizeof(uint32_t) * new_length);
                buffer_length = new_length;
            }
            buffer[count++] = p;
        }
    }
    *primes = buffer;
    return count;
}

void free_numbers(mpz_t* numbers, size_t count) {
    for (size_t i = 0; i < count; ++i)
        mpz_clear(numbers[i]);
    free(numbers);
}

// Returns an array containing first count n-smooth numbers
mpz_t* find_nsmooth_numbers(uint32_t n, uint32_t count) {
    uint32_t* primes = NULL;
    uint32_t num_primes = find_primes(2, n, &primes);
    mpz_t* numbers = xmalloc(sizeof(mpz_t) * count);
    mpz_t* queue = xmalloc(sizeof(mpz_t) * num_primes);
    uint32_t* index = xmalloc(sizeof(uint32_t) * num_primes);
    for (uint32_t i = 0; i < num_primes; ++i) {
        index[i] = 0;
        mpz_init_set_ui(queue[i], primes[i]);
    }
    for (uint32_t i = 0; i < count; ++i)
        mpz_init(numbers[i]);
    mpz_set_ui(numbers[0], 1);
    for (uint32_t i = 1; i < count; ++i) {
        for (uint32_t p = 0; p < num_primes; ++p) {
            if (mpz_cmp(queue[p], numbers[i - 1]) == 0)
                mpz_mul_ui(queue[p], numbers[++index[p]], primes[p]);
        }
        uint32_t min_index = 0;
        for (uint32_t p = 1; p < num_primes; ++p) {
            if (mpz_cmp(queue[min_index], queue[p]) > 0)
                min_index = p;
        }
        mpz_set(numbers[i], queue[min_index]);
    }
    free_numbers(queue, num_primes);
    free(primes);
    free(index);
    return numbers;
}

void print_nsmooth_numbers(uint32_t n, uint32_t begin, uint32_t count) {
    uint32_t num = begin + count;
    mpz_t* numbers = find_nsmooth_numbers(n, num);
    printf("%u: ", n);
    mpz_out_str(stdout, 10, numbers[begin]);
    for (uint32_t i = 1; i < count; ++i) {
        printf(", ");
        mpz_out_str(stdout, 10, numbers[begin + i]);
    }
    printf("\n");
    free_numbers(numbers, num);
}

int main() {
    printf("First 25 n-smooth numbers for n = 2 -> 29:\n");
    for (uint32_t n = 2; n <= 29; ++n) {
        if (is_prime(n))
            print_nsmooth_numbers(n, 0, 25);
    }
    printf("\n3 n-smooth numbers starting from 3000th for n = 3 -> 29:\n");
    for (uint32_t n = 3; n <= 29; ++n) {
        if (is_prime(n))
            print_nsmooth_numbers(n, 2999, 3);
    }
    printf("\n20 n-smooth numbers starting from 30,000th for n = 503 -> 521:\n");
    for (uint32_t n = 503; n <= 521; ++n) {
        if (is_prime(n))
            print_nsmooth_numbers(n, 29999, 20);
    }
    return 0;
}
