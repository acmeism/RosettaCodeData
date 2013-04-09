#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int m_bits, n_bits;
int *cache;

int ackermann(int m, int n)
{
        int idx, res;
        if (!m) return n + 1;

        if (n >= 1<<n_bits) {
                printf("%d, %d\n", m, n);
                idx = 0;
        } else {
                idx = (m << n_bits) + n;
                if (cache[idx]) return cache[idx];
        }

        if (!n) res = ackermann(m - 1, 1);
        else    res = ackermann(m - 1, ackermann(m, n - 1));

        if (idx) cache[idx] = res;
        return res;
}
int main()
{
        int m, n;

        m_bits = 3;
        n_bits = 20;  /* can save n values up to 2**20 - 1, that's 1 meg */
        cache = malloc(sizeof(int) * (1 << (m_bits + n_bits)));
        memset(cache, 0, sizeof(int) * (1 << (m_bits + n_bits)));

        for (m = 0; m <= 4; m++)
                for (n = 0; n < 6 - m; n++) {
                        printf("A(%d, %d) = %d\n", m, n, ackermann(m, n));

        return 0;
}
