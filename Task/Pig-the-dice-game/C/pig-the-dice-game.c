#include <stdio.h>
#include <stdlib.h>
#include <time.h>


const int NUM_PLAYERS = 2;
const int MAX_POINTS = 100;


//General functions
int randrange(int min, int max){
    return (rand() % (max - min + 1)) + min;
}


//Game functions
void ResetScores(int *scores){
    for(int i = 0; i < NUM_PLAYERS; i++){
        scores[i] = 0;
    }
}


void Play(int *scores){
    int scoredPoints = 0;
    int diceResult;
    int choice;

    for(int i = 0; i < NUM_PLAYERS; i++){
        while(1){
            printf("Player %d - You have %d total points and %d points this turn \nWhat do you want to do (1)roll or (2)hold: ", i + 1, scores[i], scoredPoints);
            scanf("%d", &choice);

            if(choice == 1){
                diceResult = randrange(1, 6);
                printf("\nYou rolled a %d\n", diceResult);

                if(diceResult != 1){
                    scoredPoints += diceResult;
                }
                else{
                    printf("You loose all your points from this turn\n\n");
                    scoredPoints = 0;
                    break;
                }
            }
            else if(choice == 2){
                scores[i] += scoredPoints;
                printf("\nYou holded, you have %d points\n\n", scores[i]);

                break;
            }
        }

        scoredPoints = 0;
        CheckForWin(scores[i], i + 1);

    }
}


void CheckForWin(int playerScore, int playerNum){
    if(playerScore >= MAX_POINTS){
        printf("\n\nCONGRATULATIONS PLAYER %d, YOU WIN\n\n!", playerNum);

        exit(EXIT_SUCCESS);
    }
}


int main()
{
    srand(time(0));

    int scores[NUM_PLAYERS];
    ResetScores(scores);

    while(1){
        Play(scores);
    }

    return 0;
}
