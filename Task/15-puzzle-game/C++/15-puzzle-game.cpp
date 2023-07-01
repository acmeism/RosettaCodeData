#include <time.h>
#include <stdlib.h>
#include <vector>
#include <string>
#include <iostream>
class p15 {
public :
    void play() {
        bool p = true;
        std::string a;
        while( p ) {
            createBrd();
            while( !isDone() ) { drawBrd();getMove(); }
            drawBrd();
            std::cout << "\n\nCongratulations!\nPlay again (Y/N)?";
            std::cin >> a; if( a != "Y" && a != "y" ) break;
        }
    }
private:
    void createBrd() {
        int i = 1; std::vector<int> v;
        for( ; i < 16; i++ ) { brd[i - 1] = i; }
        brd[15] = 0; x = y = 3;
        for( i = 0; i < 1000; i++ ) {
            getCandidates( v );
            move( v[rand() % v.size()] );
            v.clear();
        }
    }
    void move( int d ) {
        int t = x + y * 4;
        switch( d ) {
            case 1: y--; break;
            case 2: x++; break;
            case 4: y++; break;
            case 8: x--;
        }
        brd[t] = brd[x + y * 4];
        brd[x + y * 4] = 0;
    }
    void getCandidates( std::vector<int>& v ) {
        if( x < 3 ) v.push_back( 2 ); if( x > 0 ) v.push_back( 8 );
        if( y < 3 ) v.push_back( 4 ); if( y > 0 ) v.push_back( 1 );
    }
    void drawBrd() {
        int r; std::cout << "\n\n";
        for( int y = 0; y < 4; y++ ) {
            std::cout << "+----+----+----+----+\n";
            for( int x = 0; x < 4; x++ ) {
                r = brd[x + y * 4];
                std::cout << "| ";
                if( r < 10 ) std::cout << " ";
                if( !r ) std::cout << "  ";
                else std::cout << r << " ";
            }
            std::cout << "|\n";
        }
        std::cout << "+----+----+----+----+\n";
    }
    void getMove() {
        std::vector<int> v; getCandidates( v );
        std::vector<int> p; getTiles( p, v ); unsigned int i;
        while( true ) {
            std::cout << "\nPossible moves: ";
            for( i = 0; i < p.size(); i++ ) std::cout << p[i] << " ";
            int z; std::cin >> z;
            for( i = 0; i < p.size(); i++ )
                if( z == p[i] ) { move( v[i] ); return; }
        }
    }
    void getTiles( std::vector<int>& p, std::vector<int>& v ) {
        for( unsigned int t = 0; t < v.size(); t++ ) {
            int xx = x, yy = y;
            switch( v[t] ) {
                case 1: yy--; break;
                case 2: xx++; break;
                case 4: yy++; break;
                case 8: xx--;
            }
            p.push_back( brd[xx + yy * 4] );
        }
    }
    bool isDone() {
        for( int i = 0; i < 15; i++ ) {
            if( brd[i] != i + 1 ) return false;
        }
        return true;
    }
    int brd[16], x, y;
};
int main( int argc, char* argv[] ) {
    srand( ( unsigned )time( 0 ) );
    p15 p; p.play(); return 0;
}
