#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define SEQLEN 3

int getseq(char *s)
{
    int r = 0;
    int i = 1 << (SEQLEN - 1);

    while (*s && i) {
        switch (*s++) {
            case 'H':
            case 'h':
                r |= i;
                break;
            case 'T':
            case 't':
                /* 0 indicates tails, this is 0, so do nothing */
                break;
            default:
                return -1;
        }
        i >>= 1;
    }

    return r;
}

void printseq(int seq)
{
    int i;
    for (i = SEQLEN - 1; i >= 0; --i)
        printf("%c", seq & (1 << i) ? 'h' : 't');
}

int getuser(void)
{
    int user;
    char s[SEQLEN + 1];

    printf("Enter your sequence of %d (h/t): ", SEQLEN);
    while (1) {
        /* This needs to be manually changed if SEQLEN is changed */
        if (scanf("%3s", s) != 1) exit(1);
        if ((user = getseq(s)) != -1) return user;
        printf("Please enter only h/t characters: ");
    }
}

int getai(int user)
{
    int ai;

    printf("Computers sequence of %d is: ", SEQLEN);
    /* The ai's perfect choice will only be perfect for SEQLEN == 3 */
    if (user == -1)
        ai = rand() & (1 << SEQLEN) - 1;
    else
        ai = (user >> 1) | ((~user << 1) & (1 << SEQLEN - 1));

    printseq(ai);
    printf("\n");
    return ai;
}

int rungame(int user, int ai)
{
    /* Generate first SEQLEN flips. We only need to store the last SEQLEN
     * tosses at any one time. */
    int last3 = rand() & (1 << SEQLEN) - 1;

    printf("Tossed sequence: ");
    printseq(last3);
    while (1) {
        if (user == last3) {
            printf("\nUser wins!\n");
            return 1;
        }

        if (ai == last3) {
            printf("\nAi wins!\n");
            return 0;
        }

        last3 = ((last3 << 1) & (1 << SEQLEN) - 2) | (rand() & 1);
        printf("%c", last3 & 1 ? 'h' : 't');
    }
}

int main(void)
{
    srand(time(NULL));
    int playerwins = 0;
    int totalgames = 0;

    /* Just use ctrl-c for exit */
    while (1) {
        int user = -1;
        int ai   = -1;

        printf("\n");
        if (rand() & 1) {
            ai   = getai(user);
            user = getuser();
        }
        else {
            user = getuser();
            ai   = getai(user);
        }

        playerwins += rungame(user, ai);
        totalgames++;

        printf("You have won %d out of %d games\n", playerwins, totalgames);
        printf("=================================\n");
    }

    return 0;
}
