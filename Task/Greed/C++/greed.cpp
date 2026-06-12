#include <windows.h>
#include <iostream>
#include <ctime>

const int WID = 79, HEI = 22;
const float NCOUNT = ( float )( WID * HEI );

class coord : public COORD {
public:
    coord( short x = 0, short y = 0 ) { set( x, y ); }
    void set( short x, short y ) { X = x; Y = y; }
};
class winConsole {
public:
    static winConsole* getInstamnce() { if( 0 == inst ) { inst = new winConsole(); } return inst; }
    void showCursor( bool s ) { CONSOLE_CURSOR_INFO ci = { 1, s }; SetConsoleCursorInfo( conOut, &ci ); }
    void setColor( WORD clr ) { SetConsoleTextAttribute( conOut, clr ); }
    void setCursor( coord p ) { SetConsoleCursorPosition( conOut, p ); }
    void flush() { FlushConsoleInputBuffer( conIn ); }
    void kill() { delete inst; }
private:
    winConsole() { conOut = GetStdHandle( STD_OUTPUT_HANDLE );
                   conIn  = GetStdHandle( STD_INPUT_HANDLE ); showCursor( false ); }
    static winConsole* inst;
    HANDLE conOut, conIn;
};
class greed {
public:
    greed() { console = winConsole::getInstamnce(); }
    ~greed() { console->kill(); }
    void play() {
        char g; do {
            console->showCursor( false ); createBoard();
            do { displayBoard(); getInput(); } while( existsMoves() );
            displayBoard(); console->setCursor( coord( 0, 24 ) ); console->setColor( 0x07 );
            console->setCursor( coord( 19,  8 ) ); std::cout << "+----------------------------------------+";
            console->setCursor( coord( 19,  9 ) ); std::cout << "|               GAME OVER                |";
            console->setCursor( coord( 19, 10 ) ); std::cout << "|            PLAY AGAIN(Y/N)?            |";
            console->setCursor( coord( 19, 11 ) ); std::cout << "+----------------------------------------+";
            console->setCursor( coord( 48, 10 ) ); console->showCursor( true ); console->flush(); std::cin >> g;
        } while( g == 'Y' || g == 'y' );
    }
private:
    void createBoard() {
        for( int y = 0; y < HEI; y++ ) {
            for( int x = 0; x < WID; x++ ) {
                brd[x + WID * y] = rand() % 9 + 1;
            }
        }
        cursor.set( rand() % WID, rand() % HEI );
        brd[cursor.X + WID * cursor.Y] = 0; score = 0;
        printScore();
    }
    void displayBoard() {
        console->setCursor( coord() ); int i;
    for( int y = 0; y < HEI; y++ ) {
            for( int x = 0; x < WID; x++ ) {
                i = brd[x + WID * y]; console->setColor( 6 + i );
                if( !i ) std::cout << " "; else std::cout << i;
            }
            std::cout << "\n";
        }
        console->setColor( 15 ); console->setCursor( cursor ); std::cout << "@";
    }
    void getInput() {
        while( 1 ) {
            if( ( GetAsyncKeyState( 'Q' ) & 0x8000 ) && cursor.X > 0 && cursor.Y > 0 ) { execute( -1, -1 ); break; }
            if( ( GetAsyncKeyState( 'W' ) & 0x8000 ) &&  cursor.Y > 0 ) { execute( 0, -1 ); break; }
            if( ( GetAsyncKeyState( 'E' ) & 0x8000 ) && cursor.X < WID - 1 && cursor.Y > 0 ) { execute( 1, -1 ); break; }
            if( ( GetAsyncKeyState( 'A' ) & 0x8000 ) && cursor.X > 0 ) { execute( -1, 0 ); break; }
            if( ( GetAsyncKeyState( 'D' ) & 0x8000 ) && cursor.X < WID - 1 ) { execute( 1, 0 ); break; }
            if( ( GetAsyncKeyState( 'Y' ) & 0x8000 ) && cursor.X > 0 && cursor.Y < HEI - 1 ) { execute( -1, 1 ); break; }
            if( ( GetAsyncKeyState( 'X' ) & 0x8000 ) && cursor.Y < HEI - 1 ) { execute( 0, 1 ); break; }
            if( ( GetAsyncKeyState( 'C' ) & 0x8000 ) && cursor.X < WID - 1 && cursor.Y < HEI - 1 ) { execute( 1, 1 ); break; }
        }
        console->flush(); printScore();
    }
    void printScore() {
        console->setCursor( coord( 0, 24 ) ); console->setColor( 0x2a );
        std::cout << "      SCORE: " << score << " : " << score * 100.f / NCOUNT << "%      ";
    }
    void execute( int x, int y ) {
        int i = brd[cursor.X + x + WID * ( cursor.Y + y )];
        if( countSteps( i, x, y ) ) {
            score += i;
            while( i ) {
                --i; cursor.X += x; cursor.Y += y;
                brd[cursor.X + WID * cursor.Y] = 0;
            }
        }
    }
    bool countSteps( int i, int x, int y ) {
        coord t( cursor.X, cursor.Y );
        while( i ) {
            --i; t.X += x; t.Y += y;
            if( t.X < 0 || t.Y < 0 || t.X >= WID || t.Y >= HEI || !brd[t.X + WID * t.Y] ) return false;
        }
        return true;
    }
    bool existsMoves() {
        int i;
        for( int y = -1; y < 2; y++ ) {
            for( int x = -1; x < 2; x++ ) {
                if( !x && !y ) continue;
                i = brd[cursor.X + x + WID * ( cursor.Y + y )];
                if( i > 0 && countSteps( i, x, y ) ) return true;
            }
        }
        return false;
    }
    winConsole* console;
    int brd[WID * HEI];
    float score; coord cursor;
};
winConsole* winConsole::inst = 0;
int main( int argc, char* argv[] ) {
    srand( ( unsigned )time( 0 ) );
    SetConsoleTitle( "Greed" );
    greed g; g.play(); return 0;
}
