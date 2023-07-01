#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int day(int y, int m, int d) {
    return 367 * y - 7 * (y + (m + 9) / 12) / 4 + 275 * m / 9 + d - 730530;
}

void cycle(int diff, int l, char *t) {
    int p = round(100 * sin(2 * M_PI * diff / l));
    printf("%12s cycle: %3i%%", t, p);
    if (abs(p) < 15)
        printf(" (critical day)");
    printf("\n");
}

int main(int argc, char *argv[]) {
    int diff;

    if (argc < 7) {
        printf("Usage:\n");
        printf("cbio y1 m1 d1 y2 m2 d2\n");
        exit(1);
    }
    diff = abs(day(atoi(argv[1]), atoi(argv[2]), atoi(argv[3]))
             - day(atoi(argv[4]), atoi(argv[5]), atoi(argv[6])));
    printf("Age: %u days\n", diff);
    cycle(diff, 23, "Physical");
    cycle(diff, 28, "Emotional");
    cycle(diff, 33, "Intellectual");
}
