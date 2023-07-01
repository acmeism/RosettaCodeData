#include <stdio.h>

int
main() {
    int max = 0, i = 0, sixes, nines, twenties;

loopstart: while (i < 100) {
        for (sixes = 0; sixes*6 < i; sixes++) {
            if (sixes*6 == i) {
                i++;
                goto loopstart;
            }

            for (nines = 0; nines*9 < i; nines++) {
                if (sixes*6 + nines*9 == i) {
                    i++;
                    goto loopstart;
                }

                for (twenties = 0; twenties*20 < i; twenties++) {
                    if (sixes*6 + nines*9 + twenties*20 == i) {
                        i++;
                        goto loopstart;
                    }
                }
            }
        }
        max = i;
        i++;
    }

    printf("Maximum non-McNuggets number is %d\n", max);

    return 0;
}
