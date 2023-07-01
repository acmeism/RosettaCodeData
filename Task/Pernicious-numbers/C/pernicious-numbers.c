#include <stdio.h>

typedef unsigned uint;
uint is_pern(uint n)
{
        uint c = 2693408940u; // int with all prime-th bits set
        while (n) c >>= 1, n &= (n - 1); // take out lowerest set bit one by one
        return c & 1;
}

int main(void)
{
        uint i, c;
        for (i = c = 0; c < 25; i++)
                if (is_pern(i))
                        printf("%u ", i), ++c;
        putchar('\n');

        for (i = 888888877u; i <= 888888888u; i++)
                if (is_pern(i))
                        printf("%u ", i);
        putchar('\n');

        return 0;
}
