#include <windows.h>
#include <ctime>
#include <iostream>
#include <string>

const int WID = 60, HEI = 30, MAX_LEN = 600;
enum DIR { NORTH, EAST, SOUTH, WEST };

class snake {
public:
    snake() {
        console = GetStdHandle( STD_OUTPUT_HANDLE ); SetConsoleTitle( "Snake" );
        COORD coord = { WID + 1, HEI + 2 }; SetConsoleScreenBufferSize( console, coord );
        SMALL_RECT rc = { 0, 0, WID, HEI + 1 }; SetConsoleWindowInfo( console, TRUE, &rc );
        CONSOLE_CURSOR_INFO ci = { 1, false }; SetConsoleCursorInfo( console, &ci );
    }
    void play() {
        std::string a;
        while( 1 ) {
            createField(); alive = true;
            while( alive ) { drawField(); readKey(); moveSnake(); Sleep( 50 ); }
            COORD c = { 0, HEI + 1 }; SetConsoleCursorPosition( console, c );
            SetConsoleTextAttribute( console, 0x000b );
            std::cout << "Play again [Y/N]? "; std::cin >> a;
            if( a.at( 0 ) != 'Y' && a.at( 0 ) != 'y' ) return;
        }
    }
private:
    void createField() {
        COORD coord = { 0, 0 }; DWORD c;
        FillConsoleOutputCharacter( console, ' ', ( HEI + 2 ) * 80, coord, &c );
        FillConsoleOutputAttribute( console, 0x0000, ( HEI + 2 ) * 80, coord, &c );
        SetConsoleCursorPosition( console, coord );
        int x = 0, y = 1; for( ; x < WID * HEI; x++ ) brd[x] = 0;
        for( x = 0; x < WID; x++ ) {
            brd[x] = brd[x + WID * ( HEI - 1 )] = '+';
        }
        for( ; y < HEI; y++ ) {
            brd[0 + WID * y] = brd[WID - 1 + WID * y] = '+';
        }
        do {
            x = rand() % WID; y = rand() % ( HEI >> 1 ) + ( HEI >> 1 );
        } while( brd[x + WID * y] );
        brd[x + WID * y] = '@';
        tailIdx = 0; headIdx = 4; x = 3; y = 2;
        for( int c = tailIdx; c < headIdx; c++ ) {
            brd[x + WID * y] = '#';
            snk[c].X = 3 + c; snk[c].Y = 2;
        }
        head = snk[3]; dir = EAST; points = 0;
    }
    void readKey() {
        if( GetAsyncKeyState( 39 ) & 0x8000 ) dir = EAST;
        if( GetAsyncKeyState( 37 ) & 0x8000 ) dir = WEST;
        if( GetAsyncKeyState( 38 ) & 0x8000 ) dir = NORTH;
        if( GetAsyncKeyState( 40 ) & 0x8000 ) dir = SOUTH;
    }
    void drawField() {
        COORD coord; char t;
        for( int y = 0; y < HEI; y++ ) {
            coord.Y = y;
            for( int x = 0; x < WID; x++ ) {
                t = brd[x + WID * y]; if( !t ) continue;
                coord.X = x; SetConsoleCursorPosition( console, coord );
                if( coord.X == head.X && coord.Y == head.Y ) {
                    SetConsoleTextAttribute( console, 0x002e );
                    std::cout << 'O'; SetConsoleTextAttribute( console, 0x0000 );
                    continue;
                }
                switch( t ) {
                    case '#': SetConsoleTextAttribute( console, 0x002a ); break;
                    case '+': SetConsoleTextAttribute( console, 0x0019 ); break;
                    case '@': SetConsoleTextAttribute( console, 0x004c ); break;
                }
                std::cout << t; SetConsoleTextAttribute( console, 0x0000 );
            }
        }
        std::cout << t; SetConsoleTextAttribute( console, 0x0007 );
        COORD c = { 0, HEI }; SetConsoleCursorPosition( console, c );
        std::cout << "Points: " << points;
    }
    void moveSnake() {
        switch( dir ) {
            case NORTH: head.Y--; break;
            case EAST: head.X++; break;
            case SOUTH: head.Y++; break;
            case WEST: head.X--; break;
        }
        char t = brd[head.X + WID * head.Y];
        if( t && t != '@' ) { alive = false; return; }
        brd[head.X + WID * head.Y] = '#';
        snk[headIdx].X = head.X; snk[headIdx].Y = head.Y;
        if( ++headIdx >= MAX_LEN ) headIdx = 0;
        if( t == '@' ) {
            points++; int x, y;
            do {
                x = rand() % WID; y = rand() % ( HEI >> 1 ) + ( HEI >> 1 );
            } while( brd[x + WID * y] );
            brd[x + WID * y] = '@'; return;
        }
        SetConsoleCursorPosition( console, snk[tailIdx] ); std::cout << ' ';
        brd[snk[tailIdx].X + WID * snk[tailIdx].Y] = 0;
        if( ++tailIdx >= MAX_LEN ) tailIdx = 0;
    }
    bool alive; char brd[WID * HEI];
    HANDLE console; DIR dir; COORD snk[MAX_LEN];
    COORD head; int tailIdx, headIdx, points;
};
int main( int argc, char* argv[] ) {
    srand( static_cast<unsigned>( time( NULL ) ) );
    snake s; s.play(); return 0;
}
