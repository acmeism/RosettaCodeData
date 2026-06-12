#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>

#define DIGITS 1000
#define NUMSIZE 5

uint8_t randomDigit() {
    uint8_t d;
    do {d = rand() & 0xF;} while (d >= 10);
    return d;
}

int numberAt(uint8_t *d, int size) {
    int acc = 0;
    while (size--) acc = 10*acc + *d++;
    return acc;
}

int main() {
    uint8_t digits[DIGITS];
    int i, largest = 0;

    srand(time(NULL));

    for (i=0; i<DIGITS; i++) digits[i] = randomDigit();
    for (i=0; i<DIGITS-NUMSIZE; i++) {
        int here = numberAt(&digits[i], NUMSIZE);
        if (here > largest) largest = here;
    }

    printf("%d\n", largest);
    return 0;
}
