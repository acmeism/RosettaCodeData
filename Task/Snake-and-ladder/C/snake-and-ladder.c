#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

bool sixesThrowAgain = true;

void init() {
    srand((unsigned int)time(NULL));
}

int rollDice() {
    return rand() % 6 + 1;
}

int nextSquare(int square) {
    switch (square) {
    case  4:  return 14;
    case  9:  return 31;
    case 17:  return  7;
    case 20:  return 38;
    case 28:  return 84;
    case 40:  return 59;
    case 51:  return 67;
    case 54:  return 34;
    case 62:  return 19;
    case 63:  return 81;
    case 64:  return 60;
    case 71:  return 91;
    case 87:  return 24;
    case 93:  return 73;
    case 95:  return 75;
    case 99:  return 78;
    default: return square;
    }
}

int turn(int player, int square) {
    int roll, next;
    while (true) {
        roll = rollDice();
        printf("Player %d, on square %d, rolls a %d", player, square, roll);
        if (square + roll > 100) {
            printf(" but cannot move.\n");
        } else {
            square += roll;
            printf(" and moves to square %d\n", square);
            if (square == 100) return 100;
            next = nextSquare(square);
            if (square < next) {
                printf("Yay! Landed on a ladder. Climb up to %d.\n", next);
                square = next;
            } else if (next < square) {
                printf("Oops! landed on a snake. Slither down to %d.\n", next);
                square = next;
            }
        }
        if (roll < 6 || !sixesThrowAgain) return square;
        printf("Rolled a 6 so roll again.\n");
    }
}

int main() {
    int players[3] = { 1, 1, 1 };
    int i, ns;

    init();

    while (true) {
        for (i = 0; i < sizeof(players) / sizeof(int); ++i) {
            ns = turn(i + 1, players[i]);
            if (ns == 100) {
                printf("Player %d wins!\n", i + 1);
                goto out;
            }
            players[i] = ns;
            printf("\n");
        }
    }

out:
    return 0;
}
