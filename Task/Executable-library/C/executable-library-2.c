#include <stdio.h>
#include <stdlib.h>

long hailstone(long n, long **seq)
{
        long len = 0, buf_len = 4;
        if (seq)
                *seq = malloc(sizeof(long) * buf_len);

        while (1) {
                if (seq) {
                        if (len >= buf_len) {
                                buf_len *= 2;
                                *seq = realloc(*seq, sizeof(long) * buf_len);
                        }
                        (*seq)[len] = n;
                }
                len ++;
                if (n == 1) break;
                if (n & 1) n = 3 * n + 1;
                else n >>= 1;
        }
        return len;
}

void free_sequence(long * s) { free(s); }

const char my_interp[] __attribute__((section(".interp"))) = "/lib/ld-linux.so.2";
/* "ld-linux.so.2" should be whatever you use on your platform */

int hail_main() /* entry point when running along, see compiler command line */
{
        long i, *seq;

        long len = hailstone(27, &seq);
        printf("27 has %ld numbers in sequence:\n", len);
        for (i = 0; i < len; i++) {
                printf("%ld ", seq[i]);
        }
        printf("\n");
        free_sequence(seq);

        exit(0);
}
