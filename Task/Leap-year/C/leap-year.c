#include <stdio.h>

int is_leap_year(int year)
{
    return (!(year % 4) && year % 100 || !(year % 400)) ? 1 : 0;
}

int main()
{
    int test_case[] = {1900, 1994, 1996, 1997, 2000}, key, end, year;
    for (key = 0, end = sizeof(test_case)/sizeof(test_case[0]); key < end; ++key) {
        year = test_case[key];
        printf("%d is %sa leap year.\n", year, (is_leap_year(year) == 1 ? "" : "not "));
    }
}
