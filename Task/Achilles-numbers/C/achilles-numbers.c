#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>

bool is_prime(int n) {
    if (n < 2) return false;
    if (n % 2 == 0 && n != 2) return false;
    for (int i = 3; i <= sqrt(n); i += 2) {
        if (n % i == 0) return false;
    }
    return true;
}

int phi(int n) {
    int result = n;
    for (int p = 2; p * p <= n; p++) {
        if (n % p == 0) {
            while (n % p == 0) n /= p;
            result -= result / p;
        }
    }
    if (n > 1) result -= result / n;
    return result;
}

bool is_powerful(int n) {
    int m = n;
    for (int p = 2; p * p <= n; p++) {
        if (m % p == 0) {
            int exp = 0;
            while (m % p == 0) {
                m /= p;
                exp++;
            }
            if (exp < 2) return false;
        }
    }
    if (m > 1) return false;
    return true;
}

bool is_perfect_power(int n) {
    for (int k = 2; k <= log2(n); k++) {
        double root = pow(n, 1.0 / k);
        int r = round(root);
        if (pow(r, k) == n) return true;
    }
    return false;
}

bool is_achilles(int n) {
    return is_powerful(n) && !is_perfect_power(n);
}

int main() {
    int *achilles = NULL, *strong = NULL;
    int a_count = 0, s_count = 0;
    int digit_counts[7] = {0};

    for (int n = 2; a_count < 50 || s_count < 50; n++) {
        if (is_achilles(n)) {
            if (a_count < 50){
                achilles = realloc(achilles, (a_count+1)*sizeof(int));
                achilles[a_count++] = n;
            }

            int ph = phi(n);
            if (is_achilles(ph)) {
                if (s_count < 50){
                    strong = realloc(strong, (s_count+1)*sizeof(int));
                    strong[s_count++] = n;
                }
            }

        }
    }

    for (int n = 2; n <= 1000000; n++) {
        if (is_achilles(n)) {
            int digits = floor(log10(n)) + 1;
            if (digits >= 2 && digits <= 15) {
                digit_counts[digits]++;
            }
        }
    }

    printf("First 50 Achilles numbers:\n");
    for (int i = 0; i < 50; i++) {
        printf("%d ", achilles[i]);
    }
    printf("\n\n");

    printf("First 50 Strong Achilles numbers:\n");
    for (int i = 0; i < 50; i++) {
        printf("%d ", strong[i]);
    }
    printf("\n\n");

    for (int d = 2; d <= 6; d++) {
        printf("Achilles numbers with %d digits: %d\n", d, digit_counts[d]);
    }

    return 0;
}
