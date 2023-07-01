/*
 * RosettaCode: Fifteen puzle game, C89, plain vanillia TTY, MVC
 */

#define _CRT_SECURE_NO_WARNINGS /* unlocks printf etc. in MSVC */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

enum Move { MOVE_UP = 0, MOVE_DOWN = 1, MOVE_LEFT = 2, MOVE_RIGHT = 3 };

/* *****************************************************************************
 * Model
 */

#define NROWS     4
#define NCOLLUMNS 4
int holeRow;
int holeCollumn;
int cells[NROWS][NCOLLUMNS];
const int nShuffles = 100;

int Game_update(enum Move move){
    const int dx[] = {  0,  0, -1, +1 };
    const int dy[] = { -1, +1,  0,  0 };
    int i = holeRow     + dy[move];
    int j = holeCollumn + dx[move];
    if ( i >= 0 && i < NROWS && j >= 0 && j < NCOLLUMNS ){
        cells[holeRow][holeCollumn] = cells[i][j];
        cells[i][j] = 0; holeRow = i; holeCollumn = j;
        return 1;
    }
    return 0;
}

void Game_setup(void){
    int i,j,k;
    for ( i = 0; i < NROWS; i++ )
        for ( j = 0; j < NCOLLUMNS; j++ )
            cells[i][j] = i * NCOLLUMNS + j + 1;
    cells[NROWS-1][NCOLLUMNS-1] = 0;
    holeRow = NROWS - 1;
    holeCollumn = NCOLLUMNS - 1;
    k = 0;
    while ( k < nShuffles )
        k += Game_update((enum Move)(rand() % 4));
}

int Game_isFinished(void){
    int i,j; int k = 1;
    for ( i = 0; i < NROWS; i++ )
        for ( j = 0; j < NCOLLUMNS; j++ )
            if ( (k < NROWS*NCOLLUMNS) && (cells[i][j] != k++ ) )
                return 0;
    return 1;
}


/* *****************************************************************************
 * View
 */

void View_showBoard(){
    int i,j;
    putchar('\n');
    for ( i = 0; i < NROWS; i++ )
        for ( j = 0; j < NCOLLUMNS; j++ ){
            if ( cells[i][j] )
                printf(j != NCOLLUMNS-1 ? " %2d " : " %2d \n", cells[i][j]);
            else
                printf(j != NCOLLUMNS-1 ? " %2s " : " %2s \n", "");
        }
    putchar('\n');
}

void View_displayMessage(char* text){
    printf("\n%s\n", text);
}


/* *****************************************************************************
 * Controller
 */

enum Move Controller_getMove(void){
    int c;
    for(;;){
        printf("%s", "enter u/d/l/r : ");
        c = getchar();
        while( getchar() != '\n' )
            ;
        switch ( c ){
            case 27: exit(EXIT_SUCCESS);
            case 'd' : return MOVE_UP;
            case 'u' : return MOVE_DOWN;
            case 'r' : return MOVE_LEFT;
            case 'l' : return MOVE_RIGHT;
        }
    }
}

void Controller_pause(void){
    getchar();
}

int main(void){

    srand((unsigned)time(NULL));

    do Game_setup(); while ( Game_isFinished() );

    View_showBoard();
    while( !Game_isFinished() ){
        Game_update( Controller_getMove() );
        View_showBoard();
    }

    View_displayMessage("You win");
    Controller_pause();

    return EXIT_SUCCESS;
}
