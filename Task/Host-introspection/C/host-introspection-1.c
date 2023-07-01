#include <stdio.h>
#include <stddef.h> /* for size_t */
#include <limits.h> /* for CHAR_BIT */

int main() {
    int one = 1;

    /*
     * Best bet: size_t typically is exactly one word.
     */
    printf("word size = %d bits\n", (int)(CHAR_BIT * sizeof(size_t)));

    /*
     * Check if the least significant bit is located
     * in the lowest-address byte.
     */
    if (*(char *)&one)
        printf("little endian\n");
    else
        printf("big endian\n");
    return 0;
}
