#include <stdio.h>
#include <stdbool.h>

int proper_divisors(const int n, bool print_flag)
{
    int count = 0;

    for (int i = 1; i < n; ++i) {
        if (n % i == 0) {
            count++;
            if (print_flag)
                printf("%d ", i);
        }
    }

    if (print_flag)
        printf("\n");

    return count;
}

int main(void)
{
    for (int i = 1; i <= 10; ++i) {
        printf("%d: ", i);
        proper_divisors(i, true);
    }

    int max = 0;
    int max_i = 1;

    for (int i = 1; i <= 20000; ++i) {
        int v = proper_divisors(i, false);
        if (v >= max) {
            max = v;
            max_i = i;
        }
    }

    printf("%d with %d divisors\n", max_i, max);
    return 0;
}
