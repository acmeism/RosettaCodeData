#include <math.h>
#include <iostream>
#include <string>
#include <iomanip>
#include <vector>

class ulamSpiral {
public:
    void create( unsigned n, unsigned startWith = 1 ) {
        _lst.clear();
        if( !( n & 1 ) ) n++;
        _mx = n;
        unsigned v = n * n;
        _wd = static_cast<unsigned>( log10( static_cast<long double>( v ) ) ) + 1;
        for( unsigned u = 0; u < v; u++ )
            _lst.push_back( -1 );

        arrange( startWith );

    }
    void display( char c ) {
        if( !c ) displayNumbers();
        else displaySymbol( c );
    }

private:
    bool isPrime( unsigned u ) {
        if( u < 4 ) return u > 1;
        if( !( u % 2 ) || !( u % 3 ) ) return false;

        unsigned q = static_cast<unsigned>( sqrt( static_cast<long double>( u ) ) ),
                 c = 5;
        while( c <= q ) {
            if( !( u % c ) || !( u % ( c + 2 ) ) ) return false;
            c += 6;
        }
        return true;
    }
    void arrange( unsigned s ) {
        unsigned stp = 1, n = 1, posX = _mx >> 1,
                 posY = posX, stC = 0;
        int dx = 1, dy = 0;

        while( posX < _mx && posY < _mx ) {
            _lst.at( posX + posY * _mx ) =  isPrime( s ) ? s : 0;
            s++;

            if( dx ) {
                posX += dx;
                if( ++stC == stp ) {
                    dy = -dx;
                    dx = stC = 0;
                }
            } else {
                posY += dy;
                if( ++stC == stp ) {
                    dx = dy;
                    dy = stC = 0;
                    stp++;
                }
            }
        }
    }
    void displayNumbers() {
        unsigned ct = 0;
        for( std::vector<unsigned>::iterator i = _lst.begin(); i != _lst.end(); i++ ) {
            if( *i ) std::cout << std::setw( _wd ) << *i << " ";
            else std::cout << std::string( _wd, '*' ) << " ";
            if( ++ct >= _mx ) {
                std::cout << "\n";
                ct = 0;
            }
        }
        std::cout << "\n\n";
    }
    void displaySymbol( char c ) {
        unsigned ct = 0;
        for( std::vector<unsigned>::iterator i = _lst.begin(); i != _lst.end(); i++ ) {
            if( *i ) std::cout << c;
            else std::cout << " ";
            if( ++ct >= _mx ) {
                std::cout << "\n";
                ct = 0;
            }
        }
        std::cout << "\n\n";
    }

    std::vector<unsigned> _lst;
    unsigned _mx, _wd;
};

int main( int argc, char* argv[] )
{
    ulamSpiral ulam;
    ulam.create( 9 );
    ulam.display( 0 );
    ulam.create( 35 );
    ulam.display( '#' );
    return 0;
}
