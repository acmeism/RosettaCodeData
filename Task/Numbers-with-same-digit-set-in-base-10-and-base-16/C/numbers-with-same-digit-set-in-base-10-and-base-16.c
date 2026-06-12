#include <stdio.h>
#define LIMIT 100000

int digitset(int num, int base) {
    int set;
    for (set = 0; num; num /= base)
        set |= 1 << num % base;
    return set;
}

int main() {
    int i, c = 0;
    for (i = 0; i < LIMIT; i++)
        if (digitset(i,10) == digitset(i,16))
            printf("%6d%c", i, ++c%10 ? ' ' : '\n');
    printf("\n");
    return 0;
}
