#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define CHUNK_BYTES (32 << 8)
#define CHUNK_SIZE (CHUNK_BYTES << 6)

int field[CHUNK_BYTES];
#define GET(x) (field[(x)>>6] &  1<<((x)>>1&31))
#define SET(x) (field[(x)>>6] |= 1<<((x)>>1&31))

typedef unsigned uint;
typedef struct {
        uint *e;
        uint cap, len;
} uarray;
uarray primes, offset;

void push(uarray *a, uint n)
{
        if (a->len >= a->cap) {
                if (!(a->cap *= 2)) a->cap = 16;
                a->e = realloc(a->e, sizeof(uint) * a->cap);
        }
        a->e[a->len++] = n;
}

uint low;
void init(void)
{
        uint p, q;

        unsigned char f[1<<16];
        memset(f, 0, sizeof(f));
        push(&primes, 2);
        push(&offset, 0);
        for (p = 3; p < 1<<16; p += 2) {
                if (f[p]) continue;
                for (q = p*p; q < 1<<16; q += 2*p) f[q] = 1;
                push(&primes, p);
                push(&offset, q);
        }
        low = 1<<16;
}

void sieve(void)
{
        uint i, p, q, hi, ptop;
        if (!low) init();

        memset(field, 0, sizeof(field));

        hi = low + CHUNK_SIZE;
        ptop = sqrt(hi) * 2 + 1;

        for (i = 1; (p = primes.e[i]*2) < ptop; i++) {
                for (q = offset.e[i] - low; q < CHUNK_SIZE; q += p)
                        SET(q);
                offset.e[i] = q + low;
        }

        for (p = 1; p < CHUNK_SIZE; p += 2)
                if (!GET(p)) push(&primes, low + p);

        low = hi;
}

int main(void)
{
        uint i, p, c;

        while (primes.len < 20) sieve();
        printf("First 20:");
        for (i = 0; i < 20; i++)
                printf(" %u", primes.e[i]);
        putchar('\n');

        while (primes.e[primes.len-1] < 150) sieve();
        printf("Between 100 and 150:");
        for (i = 0; i < primes.len; i++) {
                if ((p = primes.e[i]) >= 100 && p < 150)
                        printf(" %u", primes.e[i]);
        }
        putchar('\n');

        while (primes.e[primes.len-1] < 8000) sieve();
        for (i = c = 0; i < primes.len; i++)
                if ((p = primes.e[i]) >= 7700 && p < 8000) c++;
        printf("%u primes between 7700 and 8000\n", c);

        for (c = 10; c <= 100000000; c *= 10) {
                while (primes.len < c) sieve();
                printf("%uth prime: %u\n", c, primes.e[c-1]);
        }

        return 0;
}
