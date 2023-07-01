#include <stdio.h>
#include "hailstone.h"

int main()
{
        long i, longest, longest_i, len;

        longest = 0;
        for (i = 1; i < 100000; i++) {
                len = hailstone(i, 0);
                if (len > longest) {
                        longest_i = i;
                        longest = len;
                }
        }

        printf("Longest sequence at %ld, length %ld\n", longest_i, longest);

        return 0;
}
