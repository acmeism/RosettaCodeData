#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct bit_array_tag {
    uint32_t size;
    uint32_t* array;
} bit_array;

bool bit_array_create(bit_array* b, uint32_t size) {
    uint32_t* array = calloc((size + 31)/32, sizeof(uint32_t));
    if (array == NULL)
        return false;
    b->size = size;
    b->array = array;
    return true;
}

void bit_array_destroy(bit_array* b) {
    free(b->array);
    b->array = NULL;
}

void bit_array_set(bit_array* b, uint32_t index, bool value) {
    assert(index < b->size);
    uint32_t* p = &b->array[index >> 5];
    uint32_t bit = 1 << (index & 31);
    if (value)
        *p |= bit;
    else
        *p &= ~bit;
}

bool bit_array_get(const bit_array* b, uint32_t index) {
    assert(index < b->size);
    uint32_t bit = 1 << (index & 31);
    return (b->array[index >> 5] & bit) != 0;
}

typedef struct sieve_tag {
    uint32_t limit;
    bit_array not_prime;
} sieve;

bool sieve_create(sieve* s, uint32_t limit) {
    if (!bit_array_create(&s->not_prime, limit + 1))
        return false;
    bit_array_set(&s->not_prime, 0, true);
    bit_array_set(&s->not_prime, 1, true);
    for (uint32_t p = 2; p * p <= limit; ++p) {
        if (bit_array_get(&s->not_prime, p) == false) {
            for (uint32_t q = p * p; q <= limit; q += p)
                bit_array_set(&s->not_prime, q, true);
        }
    }
    s->limit = limit;
    return true;
}

void sieve_destroy(sieve* s) {
    bit_array_destroy(&s->not_prime);
}

bool is_prime(const sieve* s, uint32_t n) {
    assert(n <= s->limit);
    return bit_array_get(&s->not_prime, n) == false;
}

bool find_prime_partition(const sieve* s, uint32_t number, uint32_t count,
                          uint32_t min_prime, uint32_t* p) {
    if (count == 1) {
        if (number >= min_prime && is_prime(s, number)) {
            *p = number;
            return true;
        }
        return false;
    }
    for (uint32_t prime = min_prime; prime < number; ++prime) {
        if (!is_prime(s, prime))
            continue;
        if (find_prime_partition(s, number - prime, count - 1,
                                 prime + 1, p + 1)) {
            *p = prime;
            return true;
        }
    }
    return false;
}

void print_prime_partition(const sieve* s, uint32_t number, uint32_t count) {
    assert(count > 0);
    uint32_t* primes = malloc(count * sizeof(uint32_t));
    if (primes == NULL) {
        fprintf(stderr, "Out of memory\n");
        return;
    }
    if (!find_prime_partition(s, number, count, 2, primes)) {
        printf("%u cannot be partitioned into %u primes.\n", number, count);
    } else {
        printf("%u = %u", number, primes[0]);
        for (uint32_t i = 1; i < count; ++i)
            printf(" + %u", primes[i]);
        printf("\n");
    }
    free(primes);
}

int main() {
    const uint32_t limit = 100000;
    sieve s = { 0 };
    if (!sieve_create(&s, limit)) {
        fprintf(stderr, "Out of memory\n");
        return 1;
    }
    print_prime_partition(&s, 99809, 1);
    print_prime_partition(&s, 18, 2);
    print_prime_partition(&s, 19, 3);
    print_prime_partition(&s, 20, 4);
    print_prime_partition(&s, 2017, 24);
    print_prime_partition(&s, 22699, 1);
    print_prime_partition(&s, 22699, 2);
    print_prime_partition(&s, 22699, 3);
    print_prime_partition(&s, 22699, 4);
    print_prime_partition(&s, 40355, 3);
    sieve_destroy(&s);
    return 0;
}
