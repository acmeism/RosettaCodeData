#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define SIM_N           5  /* Run 5 simulations */
#define PRINT_DISCARDED 1  /* Whether or not to print the discard pile */

#define min(x,y) ((x<y)?(x):(y))

typedef uint8_t card_t;

/* Return a random number from an uniform distribution (0..n-1) */
unsigned int rand_n(unsigned int n) {
    unsigned int out, mask = 1;
    /* Find how many bits to mask off */
    while (mask < n) mask = mask<<1 | 1;
    /* Generate random number */
    do {
        out = rand() & mask;
    } while (out >= n);
    return out;
}

/* Return a random card (0..51) from an uniform distribution */
card_t rand_card() {
    return rand_n(52);
}

/* Print a card */
void print_card(card_t card) {
    static char *suits = "HCDS"; /* hearts, clubs, diamonds and spades */
    static char *cards[] = {"A","2","3","4","5","6","7","8","9","10","J","Q","K"};
    printf(" %s%c", cards[card>>2], suits[card&3]);
}

/* Shuffle a pack */
void shuffle(card_t *pack) {
    int card;
    card_t temp, randpos;
    for (card=0; card<52; card++) {
        randpos = rand_card();
        temp = pack[card];
        pack[card] = pack[randpos];
        pack[randpos] = temp;
    }
}

/* Do the card trick, return whether cards match */
int trick() {
    card_t pack[52];
    card_t blacks[52/4], reds[52/4];
    card_t top, x, card;
    int blackn=0, redn=0, blacksw=0, redsw=0, result;

    /* Create and shuffle a pack */
    for (card=0; card<52; card++) pack[card] = card;
    shuffle(pack);

    /* Deal cards */
#if PRINT_DISCARDED
    printf("Discarded:"); /* Print the discard pile */
#endif
    for (card=0; card<52; card += 2) {
        top = pack[card]; /* Take card */
        if (top & 1) { /* Add next card to black or red pile */
            blacks[blackn++] = pack[card+1];
        } else {
            reds[redn++] = pack[card+1];
        }
#if PRINT_DISCARDED
        print_card(top); /* Show which card is discarded */
#endif
    }
#if PRINT_DISCARDED
    printf("\n");
#endif

    /* Swap an amount of cards */
    x = rand_n(min(blackn, redn));
    for (card=0; card<x; card++) {
        /* Pick a random card from the black and red pile to swap */
        blacksw = rand_n(blackn);
        redsw = rand_n(redn);
        /* Swap them */
        top = blacks[blacksw];
        blacks[blacksw] = reds[redsw];
        reds[redsw] = top;
    }

    /* Verify the assertion */
    result = 0;
    for (card=0; card<blackn; card++)
        result += (blacks[card] & 1) == 1;
    for (card=0; card<redn; card++)
        result -= (reds[card] & 1) == 0;
    result = !result;

    printf("The number of black cards in the 'black' pile"
           " %s the number of red cards in the 'red' pile.\n",
           result? "equals" : "does not equal");
    return result;
}

int main() {
    unsigned int seed, i, successes = 0;
    FILE *r;

    /* Seed the RNG with bytes from from /dev/urandom */
    if ((r = fopen("/dev/urandom", "r")) == NULL) {
        fprintf(stderr, "cannot open /dev/urandom\n");
        return 255;
    }
    if (fread(&seed, sizeof(unsigned int), 1, r) != 1) {
        fprintf(stderr, "failed to read from /dev/urandom\n");
        return 255;
    }
    fclose(r);
    srand(seed);

    /* Do simulations. */
    for (i=1; i<=SIM_N; i++) {
        printf("Simulation %d\n", i);
        successes += trick();
        printf("\n");
    }

    printf("Result: %d successes out of %d simulations\n",
        successes, SIM_N);

    return 0;
}
