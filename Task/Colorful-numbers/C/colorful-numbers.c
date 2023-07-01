#include <locale.h>
#include <stdbool.h>
#include <stdio.h>
#include <time.h>

bool colorful(int n) {
    // A colorful number cannot be greater than 98765432.
    if (n < 0 || n > 98765432)
        return false;
    int digit_count[10] = {};
    int digits[8] = {};
    int num_digits = 0;
    for (int m = n; m > 0; m /= 10) {
        int d = m % 10;
        if (n > 9 && (d == 0 || d == 1))
            return false;
        if (++digit_count[d] > 1)
            return false;
        digits[num_digits++] = d;
    }
    // Maximum number of products is (8 x 9) / 2.
    int products[36] = {};
    for (int i = 0, product_count = 0; i < num_digits; ++i) {
        for (int j = i, p = 1; j < num_digits; ++j) {
            p *= digits[j];
            for (int k = 0; k < product_count; ++k) {
                if (products[k] == p)
                    return false;
            }
            products[product_count++] = p;
        }
    }
    return true;
}

static int count[8];
static bool used[10];
static int largest = 0;

void count_colorful(int taken, int n, int digits) {
    if (taken == 0) {
        for (int d = 0; d < 10; ++d) {
            used[d] = true;
            count_colorful(d < 2 ? 9 : 1, d, 1);
            used[d] = false;
        }
    } else {
        if (colorful(n)) {
            ++count[digits - 1];
            if (n > largest)
                largest = n;
        }
        if (taken < 9) {
            for (int d = 2; d < 10; ++d) {
                if (!used[d]) {
                    used[d] = true;
                    count_colorful(taken + 1, n * 10 + d, digits + 1);
                    used[d] = false;
                }
            }
        }
    }
}

int main() {
    setlocale(LC_ALL, "");

    clock_t start = clock();

    printf("Colorful numbers less than 100:\n");
    for (int n = 0, count = 0; n < 100; ++n) {
        if (colorful(n))
            printf("%2d%c", n, ++count % 10 == 0 ? '\n' : ' ');
    }

    count_colorful(0, 0, 0);
    printf("\n\nLargest colorful number: %'d\n", largest);

    printf("\nCount of colorful numbers by number of digits:\n");
    int total = 0;
    for (int d = 0; d < 8; ++d) {
        printf("%d   %'d\n", d + 1, count[d]);
        total += count[d];
    }
    printf("\nTotal: %'d\n", total);

    clock_t end = clock();
    printf("\nElapsed time: %f seconds\n",
           (end - start + 0.0) / CLOCKS_PER_SEC);
    return 0;
}
