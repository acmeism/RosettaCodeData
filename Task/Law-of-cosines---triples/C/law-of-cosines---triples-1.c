/*
 * RossetaCode: Law of cosines - triples
 *
 * An quick and dirty brute force solutions with O(N^3) cost.
 * Anyway it is possible set MAX_SIDE_LENGTH equal to 10000
 * and use fast computer to obtain the "extra credit" badge.
 *
 * Obviously, there are better algorithms.
 */

#include <stdio.h>
#include <math.h>

#define MAX_SIDE_LENGTH 13
//#define DISPLAY_TRIANGLES 1

int main(void)
{
    static char description[3][80] = {
        "gamma =  90 degrees,  a*a + b*b       == c*c",
        "gamma =  60 degrees,  a*a + b*b - a*b == c*c",
        "gamma = 120 degrees,  a*a + b*b + a*b == c*c"
    };
    static int coeff[3] = { 0, 1, -1 };

    for (int k = 0; k < 3; k++)
    {
        int counter = 0;
        for (int a = 1; a <= MAX_SIDE_LENGTH; a++)
            for (int b = 1; b <= a; b++)
                for (int c = 1; c <= MAX_SIDE_LENGTH; c++)
                    if (a * a + b * b - coeff[k] * a * b == c * c)
                    {
                        counter++;
#ifdef DISPLAY_TRIANGLES
                        printf("  %d  %d  %d\n", a, b, c);
#endif
                    }
        printf("%s,  number of triangles = %d\n", description[k], counter);
    }

    return 0;
}
