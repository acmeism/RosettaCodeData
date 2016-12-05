#include <stdlib.h>
#include <time.h>
#include <stdio.h>

#define LOWER 0
#define UPPER 19

int main() {
    srand(time(NULL));

    for (;;) {
        unsigned a = LOWER + rand() / (RAND_MAX / (UPPER - LOWER + 1) + 1);
        printf("%d\n", a);
        if (a == 10) break;
    }
    return 0;
}
