/*
 * RossetaCode: Law of cosines - triples
 *
 * A solutions with O(N^2) cost.
 */

#include <stdio.h>
#include <math.h>

#define MAX_SIDE_LENGTH 10000
//#define DISPLAY_TRIANGLES

int main(void)
{
    static char description[3][80] = {
        "gamma =  90 degrees,  a*a + b*b       == c*c",
        "gamma =  60 degrees,  a*a + b*b - a*b == c*c",
        "gamma = 120 degrees,  a*a + b*b + a*b == c*c"
    };
    static int coeff[3] = { 0, 1, -1 };

    printf("MAX SIDE LENGTH = %d\n\n", MAX_SIDE_LENGTH);

    for (int k = 0; k < 3; k++)
    {
        int counter = 0;
        for (int a = 1; a <= MAX_SIDE_LENGTH; a++)
            for (int b = 1; b <= a; b++)
            {
                int cc = a * a + b * b - coeff[k] * a * b;
                int c = (int)(sqrt(cc) + 0.5);
                if (c <= MAX_SIDE_LENGTH && c * c == cc)
                {
#ifdef DISPLAY_TRIANGLES
                    printf("%d %d %d\n", a, b, c);
#endif
                    counter++;
                }
            }
        printf("%s,  number of triangles = %d\n", description[k], counter);
    }

    return 0;
}
