#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>

#define MAX_DIGITS 9
#define MAX_LIMIT 987654321

// ------------------ Prime Check ------------------

// Check if a number is prime
bool is_prime(int n) {
    if (n < 2) return false;
    if (n == 2) return true;
    if (n % 2 == 0) return false;

    int sqrt_n = (int)sqrt(n);
    for (int i = 3; i <= sqrt_n; i += 2) {
        if (n % i == 0) return false;
    }
    return true;
}

// ------------------ Permutation Utilities ------------------

// Swap two characters in a string
void swap(char *a, char *b) {
    char tmp = *a;
    *a = *b;
    *b = tmp;
}

// Convert digit character array to integer
int char_array_to_int(const char *arr, int len) {
    char buffer[MAX_DIGITS + 1];
    strncpy(buffer, arr, len);
    buffer[len] = '\0';
    return atoi(buffer);
}

// Recursive function to generate permutations and process each one
void generate_permutations(char *digits, int start, int end, int limit,
                           int *count_total, int *count_primes, int *max_prime) {
    if (start == end) {
        int num = char_array_to_int(digits, end + 1);
        if (num < limit) {
            (*count_total)++;
            if (is_prime(num)) {
                (*count_primes)++;
                if (num > *max_prime) *max_prime = num;
            }
        }
        return;
    }

    for (int i = start; i <= end; i++) {
        swap(&digits[start], &digits[i]);
        generate_permutations(digits, start + 1, end, limit, count_total, count_primes, max_prime);
        swap(&digits[start], &digits[i]); // backtrack
    }
}

// ------------------ Main Logic ------------------

// Generate base digit string like "123...n"
void build_digit_string(char *dest, int n) {
    for (int i = 0; i < n; i++) {
        dest[i] = '1' + i;
    }
    dest[n] = '\0';
}

void find_pandigital_primes(int limit) {
    int count_total = 0;
    int count_primes = 0;
    int max_prime = 0;

    char digits[MAX_DIGITS + 1];

    for (int n = 1; n <= MAX_DIGITS; n++) {
        build_digit_string(digits, n);
        generate_permutations(digits, 0, n - 1, limit, &count_total, &count_primes, &max_prime);
    }

    printf("Largest prime pandigital number less than %d: %d\n", limit, max_prime);
}

int main(void) {
    find_pandigital_primes(MAX_LIMIT);
    return 0;
}

