#include <ctime>
#include <iostream>
#include <string>
#include <algorithm>

class chessBoard {
public:
    void generateRNDBoard( int brds ) {
        int a, b, i; char c;
        for( int cc = 0; cc < brds; cc++ ) {
            memset( brd, 0, 64 );
            std::string pieces = "PPPPPPPPNNBBRRQKppppppppnnbbrrqk";
            random_shuffle( pieces.begin(), pieces.end() );

            while( pieces.length() ) {
                i = rand() % pieces.length(); c = pieces.at( i );
                while( true ) {
                    a = rand() % 8; b = rand() % 8;
                    if( brd[a][b] == 0 ) {
                        if( c == 'P' && !b || c == 'p' && b == 7 ||
                          ( ( c == 'K' || c == 'k' ) && search( c == 'k' ? 'K' : 'k', a, b ) ) ) continue;
                        break;
                    }
                }
                brd[a][b] = c;
                pieces = pieces.substr( 0, i ) + pieces.substr( i + 1 );
            }
            print();
        }
    }
private:
    bool search( char c, int a, int b ) {
        for( int y = -1; y < 2; y++ ) {
            for( int x = -1; x < 2; x++ ) {
                if( !x && !y ) continue;
                if( a + x > -1 && a + x < 8 && b + y >-1 && b + y < 8 ) {
                    if( brd[a + x][b + y] == c ) return true;
                }
            }
        }
        return false;
    }
    void print() {
        int e = 0;
        for( int y = 0; y < 8; y++ ) {
            for( int x = 0; x < 8; x++ ) {
                if( brd[x][y] == 0 ) e++;
                else {
                    if( e > 0 ) { std::cout << e; e = 0; }
                    std::cout << brd[x][y];
                }
            }
            if( e > 0 ) { std::cout << e; e = 0; }
            if( y < 7 ) std::cout << "/";
        }
        std::cout << " w - - 0 1\n\n";

        for( int y = 0; y < 8; y++ ) {
            for( int x = 0; x < 8; x++ ) {
                if( brd[x][y] == 0 ) std::cout << ".";
                else std::cout << brd[x][y];
            }
            std::cout << "\n";
        }

        std::cout << "\n\n";
    }
    char brd[8][8];
};
int main( int argc, char* argv[] ) {
    srand( ( unsigned )time( 0 ) );
    chessBoard c;
    c.generateRNDBoard( 2 );
    return 0;
}
