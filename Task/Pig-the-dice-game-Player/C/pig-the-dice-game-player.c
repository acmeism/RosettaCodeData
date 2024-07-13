#include <stdlib.h>
#include <stdio.h>
#include <time.h>


#define MAX_POINTS 100
#define PLAYER_COUNT 4


//Possible player moves.
typedef enum {
    ROLL,
    HOLD
} Moves;

//To allow the player definition to be used in the function definition.
typedef struct Player Player;

//This function takes the player's current score, returns 1 if the player rolls and 0 if they hold.
typedef Moves (*DeciderFunction) (Player *player);

struct Player{
    unsigned int score;
    unsigned int roundScore;
    DeciderFunction dFunction;
};

/*
    Auxiliary functions
*/
static int randrange(int min, int max){
    return (rand() % (max - min + 1)) + min;
}

//Creates a player with the given decider function.
static Player *create_player(DeciderFunction dFunction) {
    Player *player = malloc(sizeof(Player));
    player->score = 0;
    player->roundScore = 0;
    player->dFunction = dFunction;

    return player;
}

/*
    Player functions
*/
//Randomly decides whether to hold or roll.
static Moves random_player(Player *player) {
    if (player->score + player->roundScore >= MAX_POINTS)
        return HOLD;

    int num = randrange(0, 9);

    //We do the second check to make sure the player rolls at least once.
    if (num < 5 || player->roundScore == 0)
        return ROLL;
    return HOLD;
}

//Always tries to score at least a quarter of the difference between their score and "MAX_POINTS".
static Moves quarter_player(Player *player) {
    if (player->score + player->roundScore >= MAX_POINTS)
        return HOLD;

    unsigned int target = (MAX_POINTS - player->score) / 4;

    if (player->roundScore < target)
        return ROLL;
    return HOLD;
}

//Always tries to score at least fifteen points.
static Moves fifteen_player(Player *player) {
    if (player->score + player->roundScore >= MAX_POINTS)
        return HOLD;

    if (player->roundScore < 15)
        return ROLL;
    return HOLD;
}

//Behaves like the fifteen player, except they get nervous when they are close to wining.
static Moves nervous_player(Player *player) {
    if (player->score + player->roundScore >= MAX_POINTS)
        return HOLD;

    float scorePercent = (float)(1 / MAX_POINTS) * (float)(player->score + player->roundScore);

    //If the player's score is more than 75% of the total score there is a chance they will hold with less points.
    if (scorePercent >= 0.75 && player->roundScore > 6) {
        int num = randrange(0, 9);

        if (num < 5)
            return ROLL;
        return HOLD;
    }

    if (player->roundScore < 15)
        return ROLL;
    return HOLD;
}

/*
    Game functions.
*/
//Given a player it plays as long as the decider function allows it.
static void play(Player *player) {
    while (1) {
        if (player->dFunction(player) == ROLL) {
            int roll = randrange(1, 6);

            if (roll > 1) {
                player->roundScore += roll;
                fprintf(stdout, "Player rolls a %d - Round score: %d\n", roll, player->roundScore);
            }
            else {
                //If the player rolls a 1 they loose all their points.
                player->score = 0;
                player->roundScore = 0;

                fprintf(stdout, "Player rolls a 1, they loose all their points\n");

                break;
            }
        }
        else {
            player->score += player->roundScore;
            player->roundScore = 0;

            fprintf(stdout, "Player holds\n");

            break;
        }
    }
    fprintf(stdout, "Current score: %d\n", player->score);
}

static void game_controller(Player *players[]) {
    int playFlag = 1;
    while (playFlag) {
        for (int i = 0; i < PLAYER_COUNT; i++) {
            fprintf(stdout, "\nPlayer %d turn\n", i + 1);
            play(players[i]);

            //Check whether the given player has won, if so end the game and display total scores.
            if (players[i]->score >= MAX_POINTS) {
                fprintf(stdout, "\n\nPlayer %d has won", i + 1);

                puts("\n\nThe overall scores were:");
                for (int j = 0; j < PLAYER_COUNT; j++)
                    fprintf(stdout, "Player %d: %d points\n", j + 1, players[j]->score);
                puts("");

                playFlag = 0;
                break;
            }
        }
    }
}


int main () {
    //Seed the random number generator with the current system time.
    srand(time(0));

    Player *players[PLAYER_COUNT];
    players[0] = create_player(random_player);
    players[1] = create_player(quarter_player);
    players[2] = create_player(fifteen_player);
    players[3] = create_player(nervous_player);

    game_controller(players);

    for (int i = 0; i < PLAYER_COUNT; i++)
        free(players[i]);

    return 0;
}
