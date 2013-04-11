#include <stdio.h>

#define E_SMALL 1
#define E_EVEN  2
static const char *errors[] = {"too small", "even length"};

int mid3(int num, char *buf)
{
    int i, mag = 1;
    int tmp = num = num < 0 ? -num : num; /* Discard sign. */

    /* A number's magnitude can be used to determine both
     * its length and, in this case, the oddness thereof. */
    while (tmp /= 10) mag *= 10;

    if (mag < 100) return E_SMALL;
    if (mag & 128) return E_EVEN;

    while (num > 1000) {
        num -= num / mag * mag; /* Chop left digit. */
        num /= 10; /* Now the right. */
        mag /= 100;
    }

    /* Populate a character buffer to handle zeroes. */
    for (i = 2; i >= 0; num /= 10, --i)
        buf[i] = num % 10 + '0';

    return 0;
}

int main(void)
{
    int num;
    char buf[4] = "";

    while (scanf("%d", &num) != EOF) {
        printf("%d: ", num);

        if ((num = mid3(num, buf)) == 0)
            printf("%s\n", buf);
        else
            puts(errors[--num]);
    }

    return 0;
}
