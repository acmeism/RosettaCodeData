#include <assert.h>
#include <locale.h>
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
    uint32_t* p = &b->array[index >> 5];
    uint32_t bit = 1 << (index & 31);
    return (*p & bit) != 0;
}

typedef struct sieve_tag {
    uint32_t limit;
    bit_array not_prime;
} sieve;

bool sieve_create(sieve* s, uint32_t limit) {
    if (!bit_array_create(&s->not_prime, limit/2))
        return false;
    for (uint32_t p = 3; p * p <= limit; p += 2) {
        if (bit_array_get(&s->not_prime, p/2 - 1) == false) {
            uint32_t inc = 2 * p;
            for (uint32_t q = p * p; q <= limit; q += inc)
                bit_array_set(&s->not_prime, q/2 - 1, true);
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
    if (n == 2)
        return true;
    if (n < 2 || n % 2 == 0)
        return false;
    return bit_array_get(&s->not_prime, n/2 - 1) == false;
}

// return number of decimal digits
uint32_t count_digits(uint32_t n) {
    uint32_t digits = 0;
    for (; n > 0; ++digits)
        n /= 10;
    return digits;
}

// return the number with one digit replaced
uint32_t change_digit(uint32_t n, uint32_t index, uint32_t new_digit) {
    uint32_t p = 1;
    uint32_t changed = 0;
    for (; index > 0; p *= 10, n /= 10, --index)
        changed += p * (n % 10);
    changed += (10 * (n/10) + new_digit) * p;
    return changed;
}

// returns true if n unprimeable
bool unprimeable(const sieve* s, uint32_t n) {
    if (is_prime(s, n))
        return false;
    uint32_t d = count_digits(n);
    for (uint32_t i = 0; i < d; ++i) {
        for (uint32_t j = 0; j <= 9; ++j) {
            uint32_t m = change_digit(n, i, j);
            if (m != n && is_prime(s, m))
                return false;
        }
    }
    return true;
}

int main() {
    const uint32_t limit = 10000000;
    setlocale(LC_ALL, "");
    sieve s = { 0 };
    if (!sieve_create(&s, limit)) {
        fprintf(stderr, "Out of memory\n");
        return 1;
    }
    printf("First 35 unprimeable numbers:\n");
    uint32_t n = 100;
    uint32_t lowest[10] = { 0 };
    for (uint32_t count = 0, found = 0; n < limit && (found < 10 || count < 600); ++n) {
        if (unprimeable(&s, n)) {
            if (count < 35) {
                if (count != 0)
                    printf(", ");
                printf("%'u", n);
            }
            ++count;
            if (count == 600)
                printf("\n600th unprimeable number: %'u\n", n);
            uint32_t last_digit = n % 10;
            if (lowest[last_digit] == 0) {
                lowest[last_digit] = n;
                ++found;
            }
        }
    }
    sieve_destroy(&s);
    for (uint32_t i = 0; i < 10; ++i)
        printf("Least unprimeable number ending in %u: %'u\n" , i, lowest[i]);
    return 0;
}
