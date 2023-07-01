/**
 * RosettaCode: Fifteen puzle game, C89, MS Windows Console API, MVC
 *
 * @version 0.2 (added TTY and ncurses modes)
 */

#define UNDEFINED_WIN32API_CONSOLE
#define UNDEFINED_NCURSES_CONSOLE
#if !defined (TTY_CONSOLE) && !defined(WIN32API_CONSOLE) && !defined(NCURSES_CONSOLE)
#define TTY_CONSOLE
#endif

#define _CRT_SECURE_NO_WARNINGS    /* enable printf etc. */
#define _CRT_NONSTDC_NO_DEPRECATE  /* POSIX functions enabled */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#if defined(NCURSES_CONSOLE)
#include "curses.h"  /* see http://pdcurses.sourceforge.net/ */
#elif defined(WIN32API_CONSOLE)
#define NOGDI                   /* we don't need GDI */
#define WIN32_LEAN_AND_MEAN     /* we don't need OLE etc. */
#include <windows.h>            /* MS Windows stuff */
#include <conio.h>              /* kbhit() and getch() */
#endif

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

int fieldWidth;
#ifdef WIN32API_CONSOLE
HANDLE hConsole;
CONSOLE_SCREEN_BUFFER_INFO csbi;
#endif

void View_setup_base(void)
{
    int i;
    fieldWidth = 0;
    for ( i = NROWS * NCOLLUMNS - 1; i > 0; i /= 10 )
        fieldWidth++;
}

#if defined(TTY_CONSOLE)

void View_setup(void) {
    View_setup_base();
}

void View_showBoard()
{
    int i,j;
    putchar('\n');
    for ( i = 0; i < NROWS; i++ )
        for ( j = 0; j < NCOLLUMNS; j++ ){
            if ( cells[i][j] )
                printf(j != NCOLLUMNS-1 ? " %*d " : " %*d \n", fieldWidth, cells[i][j]);
            else
                printf(j != NCOLLUMNS-1 ? " %*s " : " %*s \n", fieldWidth, "");
        }
    putchar('\n');
}

void View_displayMessage(char* text)
{
    printf("\n%s\n", text);
}

#elif defined(NCURSES_CONSOLE)

void View_setup(void) {
    View_setup_base();
    initscr();
    clear();
}

void View_showBoard()
{
    int i,j;
    for ( i = 0; i < NROWS; i++ )
        for ( j = 0; j < NCOLLUMNS; j++ ){
            int x = (fieldWidth+1)*j;
            int y = 2*i;
            if ( cells[i][j] ){
                attron(A_REVERSE);
                mvprintw(y,x,"%*d", fieldWidth, cells[i][j]);
            }else{
                attroff(A_REVERSE);
                mvprintw(y,x,"%*s", fieldWidth, " ");
            }
        }
    attrset(A_NORMAL);
}

void View_displayMessage(char* text)
{
    mvprintw(2*NROWS,0, "%s", text);
}

#elif defined(WIN32API_CONSOLE)

void View_setup(void) {
    const COORD coordHome = { 0, 0 };
    CONSOLE_CURSOR_INFO cci;
    DWORD size, nWritten;
    View_setup_base();
    hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
    cci.bVisible = FALSE;
    cci.dwSize = 1;
    SetConsoleCursorInfo(hConsole,&cci);
    GetConsoleScreenBufferInfo(hConsole,&(csbi));
    size = csbi.dwSize.X*csbi.dwSize.Y;
    FillConsoleOutputCharacter(hConsole,' ',size,coordHome,&nWritten);
    FillConsoleOutputAttribute(hConsole,csbi.wAttributes,size,coordHome,&nWritten);

}

void View_showBoard()
{
    int i,j;
    char labelString[32];
    WORD attributes;
    DWORD nWritten;
    for ( i = 0; i < NROWS; i++ )
        for ( j = 0; j < NCOLLUMNS; j++ ){
            COORD coord = { ((SHORT)fieldWidth+1)*j, coord.Y = 2*i };
            if ( cells[i][j] ){
                sprintf(labelString,"%*d", fieldWidth, cells[i][j]);
                attributes = BACKGROUND_BLUE | BACKGROUND_GREEN | BACKGROUND_RED;
            }else{
                sprintf(labelString,"%*s", fieldWidth, " ");
                attributes = csbi.wAttributes;
            }
            WriteConsoleOutputCharacter(hConsole,labelString,fieldWidth,coord,&nWritten);
            FillConsoleOutputAttribute (hConsole,attributes,fieldWidth,coord,&nWritten);
        }
}

void View_displayMessage(char* text)
{
    DWORD nWritten;
    COORD coord = { 0, 2 * NROWS };
    WriteConsoleOutputCharacter(hConsole,text,strlen(text),coord,&nWritten);
}

#endif


/* *****************************************************************************
 * Controller
 */

#if defined(TTY_CONSOLE)

void Controller_setup(void){
}

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

void Controller_pause(void)
{
    getchar();
}

#elif defined(NCURSES_CONSOLE)

void Controller_setup(void){
    noecho();
    cbreak();
    curs_set(0);
    keypad(stdscr,TRUE);
}

enum Move Controller_getMove(void){
    for(;;){
        switch ( wgetch(stdscr) ){
            case  27: exit(EXIT_SUCCESS);
            case KEY_DOWN  : return MOVE_UP;
            case KEY_UP    : return MOVE_DOWN;
            case KEY_RIGHT : return MOVE_LEFT;
            case KEY_LEFT  : return MOVE_RIGHT;
            case ERR: /* NOP */;
        }
    }
}

void Controller_pause(void){
    while ( wgetch(stdscr) == ERR )
        ;
}


#elif defined(WIN32API_CONSOLE)

void Controller_setup(void){
}

enum Move Controller_getMove(void){
    for(;;){
        switch ( getch() ){
            case  27: exit(EXIT_SUCCESS);
            case   0:
            case 224: switch ( getch() ){
                case 80 : return MOVE_UP;
                case 72 : return MOVE_DOWN;
                case 77 : return MOVE_LEFT;
                case 75 : return MOVE_RIGHT;
            }
        }
    }
}

void Controller_pause(void){
    while(  kbhit() ) getch();
    while( !kbhit() )   ;
    while(  kbhit() ) getch();
}

#endif


/* *****************************************************************************
 * Main function: create model, view and controller. Run main loop.
 */
int main(void) {

    srand((unsigned)time(NULL));

    do Game_setup(); while ( Game_isFinished() );
    View_setup();
    Controller_setup();

    View_showBoard();
    while( !Game_isFinished() ){
        Game_update( Controller_getMove() );
        View_showBoard();
    }

    View_displayMessage("You win");
    Controller_pause();

    return EXIT_SUCCESS;
}
