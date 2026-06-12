#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

void init() {
    srand((unsigned int)time(NULL));
}

int random(int low, int high) {
    int diff, val;

    diff = high - low;
    if (diff == 0) {
        return low;
    }

    val = rand() % diff;
    return val + low;
}

void initDeck(int *deck, const int size) {
    int i;
    for (i = 0; i < size; ++i) {
        *deck++ = i + 1;
    }
}

void writeDeck(const int *deck, const int size) {
    int i;

    printf("[");
    if (size > 0) {
        printf("%d", *deck++);
    }
    for (i = 1; i < size; ++i) {
        printf(", %d", *deck++);
    }
    printf("]");
}

void riffleShuffle(int * const deck, const int size, int flips) {
    int n, cutPoint, nlp, lp, rp, bound;
    int *nl;

    nl = (int *)malloc(size * sizeof(int));

    for (n = 0; n < flips; ++n) {
        cutPoint = size / 2;
        if (random(0, 2) > 0) {
            cutPoint = cutPoint + random(0, size / 10);
        } else {
            cutPoint = cutPoint - random(0, size / 10);
        }

        nlp = 0;
        lp = 0;
        rp = cutPoint;

        while (lp < cutPoint && rp < size) {
            /* Allow for an imperfect riffling so that more than one card
               can come from the same side in a row biased towards the side
               with more cards. Remove the IF statement for perfect riffling.
            */
            bound = (cutPoint - lp) * 50 / (size - rp);
            if (random(0, 50) >= bound) {
                nl[nlp++] = deck[rp++];
            } else {
                nl[nlp++] = deck[lp++];
            }
        }
        while (lp < cutPoint) {
            nl[nlp++] = deck[lp++];
        }
        while (rp < size) {
            nl[nlp++] = deck[rp++];
        }

        memcpy(deck, nl, size * sizeof(int));
    }

    free(nl);
}

void overhandShuffle(int * const mainHand, const int size, int passes) {
    int n, cutSize, mp, op, tp, i;
    int *otherHand, *temp;

    otherHand = (int *)malloc(size * sizeof(int));
    temp = (int *)malloc(size * sizeof(int));

    for (n = 0; n < passes; ++n) {
        mp = 0;
        op = 0;
        tp = 0;

        while (mp < size) {
            cutSize = random(0, size / 5) + 1;

            /* grab the next cut up to the end of the cards left in the main hand */
            for (i = 0; i < cutSize && mp < size; ++i) {
                temp[tp++] = mainHand[mp++];
            }

            /* add them to the cards in the other hand,
               sometimes to the front sometimes to the back */
            if (random(0, 10) >= 1) {
                /* front most of the time */

                /* move the elements of other hand forward to make room for temp */
                for (i = op - 1; i >= 0; --i) {
                    otherHand[i + tp] = otherHand[i];
                }

                /* copy temp to the front of other hand */
                memcpy(otherHand, temp, tp * sizeof(int));
                op += tp;
                tp = 0;
            } else {
                /* end sometimes */
                for (i = 0; i < tp; ++i, ++op) {
                    otherHand[op] = temp[i];
                }
                tp = 0;
            }
        }

        /* move the cards back to the main hand */
        memcpy(mainHand, otherHand, size * sizeof(int));
    }

    free(otherHand);
    free(temp);
}

#define SIZE 20
int main() {
    int deck[SIZE];

    init();

    printf("Riffle shuffle\n");
    initDeck(deck, SIZE);
    writeDeck(deck, SIZE);
    printf("\n");
    riffleShuffle(deck, SIZE, 10);
    writeDeck(deck, SIZE);
    printf("\n\n");

    printf("Riffle shuffle\n");
    initDeck(deck, SIZE);
    writeDeck(deck, SIZE);
    printf("\n");
    riffleShuffle(deck, SIZE, 1);
    writeDeck(deck, SIZE);
    printf("\n\n");

    printf("Overhand shuffle\n");
    initDeck(deck, SIZE);
    writeDeck(deck, SIZE);
    printf("\n");
    overhandShuffle(deck, SIZE, 10);
    writeDeck(deck, SIZE);
    printf("\n\n");

    printf("Overhand shuffle\n");
    initDeck(deck, SIZE);
    writeDeck(deck, SIZE);
    printf("\n");
    overhandShuffle(deck, SIZE, 1);
    writeDeck(deck, SIZE);
    printf("\n\n");

    return 0;
}
