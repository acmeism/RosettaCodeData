#include <math.h>
#include <iostream>
#include <iomanip>

bool isPrime( unsigned u ) {
    if( u < 4 ) return u > 1;
    if( /*!( u % 2 ) ||*/ !( u % 3 ) ) return false;

    unsigned q = static_cast<unsigned>( sqrt( static_cast<long double>( u ) ) ),
             c = 5;
    while( c <= q ) {
        if( !( u % c ) || !( u % ( c + 2 ) ) ) return false;
        c += 6;
    }
    return true;
}
int main( int argc, char* argv[] )
{
    unsigned mx = 100000000,
             wid = static_cast<unsigned>( log10( static_cast<long double>( mx ) ) ) + 1;

    std::cout << "[" << std::setw( wid ) << 2 << " ";
    unsigned u = 3, p = 1; // <- start computing from 3
    while( u < mx ) {
        if( isPrime( u ) ) { std::cout << std::setw( wid ) << u << " "; p++; }
        u += 2;
    }
    std::cout << "]\n\n Found " << p << " primes.\n\n";
    return 0;
}
