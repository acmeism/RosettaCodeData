#include <stdio.h>

int is_leap_year(unsigned year)
{
    return !(year & (year % 100 ? 3 : 15));
}

int main(void)
{
    const unsigned test_case[] = {
        1900, 1994, 1996, 1997, 2000, 2024, 2025, 2026, 2100
    };
    const unsigned n = sizeof test_case / sizeof test_case[0];

    for (unsigned i = 0; i != n; ++i) {
        unsigned year = test_case[i];
        printf("%u is %sa leap year.\n", year, is_leap_year(year) ? "" : "not ");
    }
    return 0;
}
