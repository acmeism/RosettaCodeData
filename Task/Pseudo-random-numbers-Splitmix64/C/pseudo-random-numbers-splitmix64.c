/*  Written in 2015 by Sebastiano Vigna (vigna@acm.org)

To the extent possible under law, the author has dedicated all copyright
and related and neighboring rights to this software to the public domain
worldwide. This software is distributed without any warranty.

See <http://creativecommons.org/publicdomain/zero/1.0/>. */

#include <stdint.h>
#include <stdio.h>
#include <math.h>

/* This is a fixed-increment version of Java 8's SplittableRandom generator
   See http://dx.doi.org/10.1145/2714064.2660195 and
   http://docs.oracle.com/javase/8/docs/api/java/util/SplittableRandom.html

   It is a very fast generator passing BigCrush, and it can be useful if
   for some reason you absolutely want 64 bits of state. */

static uint64_t x; /* The state can be seeded with any value. */

uint64_t next() {
	uint64_t z = (x += 0x9e3779b97f4a7c15);
	z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9;
	z = (z ^ (z >> 27)) * 0x94d049bb133111eb;
	return z ^ (z >> 31);
}

double next_float() {
    return next() / pow(2.0, 64);
}

int main() {
    int i, j;
    x = 1234567;
    for(i = 0; i < 5; ++i)
        printf("%llu\n", next()); /* needed to use %lu verb for GCC 7.5.0-3 */
    x = 987654321;
    int vec5[5] = {0, 0, 0, 0, 0};
    for(i = 0; i < 100000; ++i) {
        j = next_float() * 5.0;
        vec5[j] += 1;
    }
    for(i = 0; i < 5; ++i)
        printf("%d: %d  ", i, vec5[i]);
}
