#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define TRUE 1
#define FALSE 0
#define ESC 27
#define TEST TRUE  /* set to 'false' to erase each player's coins */

typedef int bool;

int get_number(const char *prompt, int min, int max, bool show_mm) {
    int n;
    char *line = NULL;
    size_t len = 0;
    ssize_t read;
    fflush(stdin);
    do {
        printf("%s", prompt);
        if (show_mm)
            printf(" from %d to %d : ", min, max);
        else
            printf(" : ");
        read = getline(&line, &len, stdin);
        if (read < 2) continue;
        n = atoi(line);
    }
    while (n < min || n > max);
    printf("\n");
    return n;
}

int compare_int(const void *a, const void* b) {
    int i = *(int *)a;
    int j = *(int *)b;
    return i - j;
}

int main() {
    int i, j, n, players, coins, first, round = 1, rem_size;
    int min, max, guess, index, index2, total;
    int remaining[9], hands[10], guesses[10];
    bool found, eliminated;
    char c;
    players = get_number("Number of players", 2, 9, TRUE);
    coins = get_number("Number of coins per player", 3, 6, TRUE);
    for (i = 0; i < 9; ++i) remaining[i] = i + 1;
    rem_size = players;
    srand(time(NULL));
    first = 1 + rand() % players;
    printf("The number of coins in your hand will be randomly determined for");
    printf("\neach round and displayed to you. However, when you press ENTER");
    printf("\nit will be erased so that the other players, who should look");
    printf("\naway until it's their turn, won't see it. When asked to guess");
    printf("\nthe total, the computer won't allow a 'bum guess'.\n");
    while(TRUE) {
        printf("\nROUND %d:\n", round);
        n = first;
        for (i = 0; i < 10; ++i) {
            hands[i] = 0; guesses[i] = -1;
        }
        do {
            printf("  PLAYER %d:\n", n);
            printf("    Please come to the computer and press ENTER\n");
            hands[n] = rand() % (coins + 1);
            printf("      <There are %d coin(s) in your hand>", hands[n]);
            while (getchar() != '\n');
            if (!TEST) {
                printf("%c[1A", ESC);  // move cursor up one line
                printf("%c[2K", ESC);  // erase line
                printf("\r\n");        // move cursor to beginning of line
            }
            else printf("\n");
            while (TRUE) {
                min = hands[n];
                max = (rem_size - 1) * coins + hands[n];
                guess = get_number("    Guess the total", min, max, FALSE);
                found = FALSE;
                for (i = 1; i < 10; ++i) {
                    if (guess == guesses[i]) {
                        found = TRUE;
                        break;
                    }
                }
                if (!found) {
                    guesses[n] = guess;
                    break;
                }
                printf("    Already guessed by another player, try again\n");
            }
            index = -1;
            for (i = 0; i < rem_size; ++i) {
                if (remaining[i] == n) {
                    index = i;
                    break;
                }
            }
            if (index < rem_size - 1)
                n = remaining[index + 1];
            else
                n = remaining[0];
        }
        while (n != first);
        total = 0;
        for (i = 1; i < 10; ++i) total += hands[i];
        printf("  Total coins held = %d\n", total);
        eliminated = FALSE;
        for (i = 0; i < rem_size; ++i) {
            j = remaining[i];
            if (guesses[j] == total) {
                printf("  PLAYER %d guessed correctly and is eliminated\n", j);
                remaining[i] = 10;
                rem_size--;
                qsort(remaining, players, sizeof(int), compare_int);
                eliminated = TRUE;
                break;
            }
        }
        if (!eliminated)
            printf("  No players guessed correctly in this round\n");
        else if (rem_size == 1) {
            printf("\nPLAYER %d buys the drinks!\n", remaining[0]);
            break;
        }
        index2 = -1;
        for (i = 0; i < rem_size; ++i) {
            if (remaining[i] == first) {
                index2 = i;
                break;
            }
        }
        if (index2 < rem_size - 1)
            first = remaining[index2 + 1];
        else
            first = remaining[0];
        round++;
    }
    return 0;
}
