#include <iostream>
#include <vector>
#include <iomanip>

void primeFactors( unsigned n, std::vector<unsigned>& r ) {
    int f = 2; if( n == 1 ) r.push_back( 1 );
    else {
        while( true ) {
            if( !( n % f ) ) {
                r.push_back( f );
                n /= f; if( n == 1 ) return;
            }
            else f++;
        }
    }
}
unsigned sumDigits( unsigned n ) {
    unsigned sum = 0, m;
    while( n ) {
        m = n % 10; sum += m;
        n -= m; n /= 10;
    }
    return sum;
}
unsigned sumDigits( std::vector<unsigned>& v ) {
    unsigned sum = 0;
    for( std::vector<unsigned>::iterator i = v.begin(); i != v.end(); i++ ) {
        sum += sumDigits( *i );
    }
    return sum;
}
void listAllSmithNumbers( unsigned n ) {
    std::vector<unsigned> pf;
    for( unsigned i = 4; i < n; i++ ) {
        primeFactors( i, pf ); if( pf.size() < 2 ) continue;
        if( sumDigits( i ) == sumDigits( pf ) )
            std::cout << std::setw( 4 ) << i << " ";
        pf.clear();
    }
    std::cout << "\n\n";
}
int main( int argc, char* argv[] ) {
    listAllSmithNumbers( 10000 );
    return 0;
}
