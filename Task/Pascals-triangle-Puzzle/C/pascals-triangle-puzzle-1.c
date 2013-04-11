/* Pascal's pyramid solver
 *
 *               [top]
 *            [   ] [   ]
 *         [mid] [   ] [   ]
 *      [   ] [   ] [   ] [   ]
 *   [ x ] [ a ] [ y ] [ b ] [ z ]
 *             x + z = y
 *
 * This solution makes use of a little bit of mathematical observation,
 * such as the fact that top = 4(a+b) + 7(x+z) and mid = 2x + 2a + z.
 */

#include <stdio.h>
#include <math.h>

void pascal(int a, int b, int mid, int top, int* x, int* y, int* z)
{
    double ytemp = (top - 4 * (a + b)) / 7.;
    if(fmod(ytemp, 1.) >= 0.0001)
    {
        x = 0;
        return;
    }
    *y = ytemp;
    *x = mid - 2 * a - *y;
    *z = *y - *x;
}
int main()
{
    int a = 11, b = 4, mid = 40, top = 151;
    int x, y, z;
    pascal(a, b, mid, top, &x, &y, &z);
    if(x != 0)
        printf("x: %d, y: %d, z: %d\n", x, y, z);
    else printf("No solution\n");

    return 0;
}
