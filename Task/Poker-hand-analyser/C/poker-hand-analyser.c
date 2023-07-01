#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

#define TRUE 1
#define FALSE 0

#define FACES "23456789tjqka"
#define SUITS "shdc"

typedef int bool;

typedef struct {
    int face;  /* FACES map to 0..12 respectively */
    char suit;
} card;

card cards[5];

int compare_card(const void *a, const void *b) {
    card c1 = *(card *)a;
    card c2 = *(card *)b;
    return c1.face - c2.face;
}

bool equals_card(card c1, card c2) {
    if (c1.face == c2.face && c1.suit == c2.suit) return TRUE;
    return FALSE;
}

bool are_distinct() {
    int i, j;
    for (i = 0; i < 4; ++i)
        for (j = i + 1; j < 5; ++j)
            if (equals_card(cards[i], cards[j])) return FALSE;
    return TRUE;
}

bool is_straight() {
    int i;
    qsort(cards, 5, sizeof(card), compare_card);
    if (cards[0].face + 4 == cards[4].face) return TRUE;
    if (cards[4].face == 12 && cards[0].face == 0 &&
        cards[3].face == 3) return TRUE;
    return FALSE;
}

bool is_flush() {
    int i;
    char suit = cards[0].suit;
    for (i = 1; i < 5; ++i) if (cards[i].suit != suit) return FALSE;
    return TRUE;
}

const char *analyze_hand(const char *hand) {
    int i, j, gs = 0;
    char suit, *cp;
    bool found, flush, straight;
    int groups[13];
    if (strlen(hand) != 14) return "invalid";
    for (i = 0; i < 14; i += 3) {
        cp = strchr(FACES, tolower(hand[i]));
        if (cp == NULL) return "invalid";
        j = i / 3;
        cards[j].face = cp - FACES;
        suit = tolower(hand[i + 1]);
        cp = strchr(SUITS, suit);
        if (cp == NULL) return "invalid";
        cards[j].suit = suit;
    }
    if (!are_distinct()) return "invalid";
    for (i = 0; i < 13; ++i) groups[i] = 0;
    for (i = 0; i < 5; ++i) groups[cards[i].face]++;
    for (i = 0; i < 13; ++i) if (groups[i] > 0) gs++;
    switch(gs) {
        case 2:
            found = FALSE;
            for (i = 0; i < 13; ++i) if (groups[i] == 4) {
                found = TRUE;
                break;
            }
            if (found) return "four-of-a-kind";
            return "full-house";
        case 3:
            found = FALSE;
            for (i = 0; i < 13; ++i) if (groups[i] == 3) {
                found = TRUE;
                break;
            }
            if (found) return "three-of-a-kind";
            return "two-pairs";
        case 4:
            return "one-pair";
        default:
            flush = is_flush();
            straight = is_straight();
            if (flush && straight)
                return "straight-flush";
            else if (flush)
                return "flush";
            else if (straight)
                return "straight";
            else
                return "high-card";
    }
}

int main(){
    int i;
    const char *type;
    const char *hands[10] = {
        "2h 2d 2c kc qd",
        "2h 5h 7d 8c 9s",
        "ah 2d 3c 4c 5d",
        "2h 3h 2d 3c 3d",
        "2h 7h 2d 3c 3d",
        "2h 7h 7d 7c 7s",
        "th jh qh kh ah",
        "4h 4s ks 5d ts",
        "qc tc 7c 6c 4c",
        "ah ah 7c 6c 4c"
    };
    for (i = 0; i < 10; ++i) {
        type = analyze_hand(hands[i]);
        printf("%s: %s\n", hands[i], type);
    }
    return 0;
}
