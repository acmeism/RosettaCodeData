#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

/* should be 64-bit integers if going over 1 billion */
typedef unsigned long xint;
#define FMT "%lu"

xint total, prim, max_peri;

void new_tri(xint in[])
{
    int i;
    xint t[3], p;
    xint x = in[0], y = in[1], z = in[2];

recur:  p = x + y + z;
    if (p > max_peri) return;

    prim ++;
    total += max_peri / p;

    t[0] = x - 2 * y + 2 * z;
    t[1] = 2 * x - y + 2 * z;
    t[2] = t[1] - y + z;
    new_tri(t);

    t[0] += 4 * y;
    t[1] += 2 * y;
    t[2] += 4 * y;
    new_tri(t);

    z = t[2] - 4 * x;
    y = t[1] - 4 * x;
    x = t[0] - 2 * x;
    goto recur;
}

int main()
{
    xint seed[3] = {3, 4, 5};

    for (max_peri = 10; max_peri <= 100000000; max_peri *= 10) {
        total = prim = 0;
        new_tri(seed);

        printf( "Up to "FMT": "FMT" triples, "FMT" primitives.\n",
            max_peri, total, prim);
    }
    return 0;
}
