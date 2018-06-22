#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
        int days[] = {31,29,31,30,31,30,31,31,30,31,30,31};
        int m, y, w;

        if (argc < 2 || (y = atoi(argv[1])) <= 1752) return 1;
        days[1] -= (y % 4) || (!(y % 100) && (y % 400));
        w = y * 365 + 97 * (y - 1) / 400 + 4;

        for(m = 0; m < 12; m++) {
                w = (w + days[m]) % 7;
                printf("%d-%02d-%d\n", y, m + 1,days[m] - w);
        }

        return 0;
}
