/**
 * Game 21 - an example in C language for Rosseta Code.
 *
 * A simple game program whose rules are described below
 * - see DESCRIPTION string.
 *
 * This program should be compatible with C89 and up.
 */


/*
 * Turn off MS Visual Studio panic warnings which disable to use old gold
 * library functions like printf, scanf etc. This definition should be harmless
 * for non-MS compilers.
 */
#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/*
 * Define bool, true and false as needed. The stdbool.h is a standard header
 * in C99, therefore for older compilers we need DIY booleans. BTW, there is
 * no __STDC__VERSION__ predefined macro in MS Visual C, therefore we need
 * check also _MSC_VER.
 */
#if __STDC_VERSION__ >= 199901L || _MSC_VER >= 1800
#include <stdbool.h>
#else
#define bool int
#define true  1
#define false 0
#endif

#define GOAL               21
#define NUMBER_OF_PLAYERS   2
#define MIN_MOVE            1
#define MAX_MOVE            3
#define BUFFER_SIZE       256

#define _(STRING) STRING


/*
 * Spaces are meaningful: on some systems they can be visible.
 */
static char DESCRIPTION[] =
    "21 Game                                                          \n"
    "                                                                 \n"
    "21 is a two player game, the game is played by choosing a number \n"
    "(1, 2, or 3) to be added to the running total. The game is won by\n"
    "the player whose chosen number causes the running total to reach \n"
    "exactly 21. The running total starts at zero.                    \n\n";

static int total;


void update(char* player, int move)
{
    printf("%8s:  %d = %d + %d\n\n", player, total + move, total, move);
    total += move;
    if (total == GOAL)
        printf(_("The winner is %s.\n\n"), player);
}


int ai()
{
/*
 * There is a winning strategy for the first player. The second player can win
 * then and only then the frist player does not use the winning strategy.
 *
 * The winning strategy may be defined as best move for the given running total.
 * The running total is a number from 0 to GOAL. Therefore, for given GOAL, best
 * moves may be precomputed (and stored in a lookup table). Actually (when legal
 * moves are 1 or 2 or 3) the table may be truncated to four first elements.
 */
#if GOAL < 32 && MIN_MOVE == 1 && MAX_MOVE == 3
    static const int precomputed[] = { 1, 1, 3, 2, 1, 1, 3, 2, 1, 1, 3, 2, 1, 1,
        3, 2, 1, 1, 3, 2, 1, 1, 3, 2, 1, 1, 3, 2, 1, 1, 3 };
    update(_("ai"), precomputed[total]);
#elif MIN_MOVE == 1 && MAX_MOVE == 3
    static const int precomputed[] = { 1, 1, 3, 2};
    update(_("ai"), precomputed[total % (MAX_MOVE + 1)]);
#else
    int i;
    int move = 1;
    for (i = MIN_MOVE; i <= MAX_MOVE; i++)
        if ((total + i - 1) % (MAX_MOVE + 1) == 0)
            move = i;
    for (i = MIN_MOVE; i <= MAX_MOVE; i++)
        if (total + i == GOAL)
            move = i;
    update(_("ai"), move);
#endif
}


void human(void)
{
    char buffer[BUFFER_SIZE];
    int move;

    while ( printf(_("enter your move to play (or enter 0 to exit game): ")),
            fgets(buffer, BUFFER_SIZE, stdin),
            sscanf(buffer, "%d", &move) != 1 ||
            (move && (move < MIN_MOVE || move > MAX_MOVE || total+move > GOAL)))
        puts(_("\nYour answer is not a valid choice.\n"));
    putchar('\n');
    if (!move) exit(EXIT_SUCCESS);
    update(_("human"), move);
}


int main(int argc, char* argv[])
{
    srand(time(NULL));
    puts(_(DESCRIPTION));
    while (true)
    {
        puts(_("\n---- NEW GAME ----\n"));
        puts(_("\nThe running total is currently zero.\n"));
        total = 0;

        if (rand() % NUMBER_OF_PLAYERS)
        {
            puts(_("The first move is AI move.\n"));
            ai();
        }
        else
            puts(_("The first move is human move.\n"));

        while (total < GOAL)
        {
            human();
            ai();
        }
    }
}
