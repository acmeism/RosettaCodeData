#include <iostream>
#include <iomanip>
#include <algorithm>
#include <vector>

unsigned gcd( unsigned i, unsigned j ) {
    return i ? i < j ? gcd( j % i, i ) : gcd( i % j, j ) : j;
}
void createSequence( std::vector<unsigned>& seq, int c ) {
    if( 1500 == seq.size() ) return;
    unsigned t = seq.at( c ) + seq.at( c + 1 );
    seq.push_back( t );
    seq.push_back( seq.at( c + 1 ) );
    createSequence( seq, c + 1 );
}
int main( int argc, char* argv[] ) {
    std::vector<unsigned> seq( 2, 1 );
    createSequence( seq, 0 );

    std::cout << "First fifteen members of the sequence:\n    ";
    for( unsigned x = 0; x < 15; x++ ) {
        std::cout << seq[x] << " ";
    }

    std::cout << "\n\n";
    for( unsigned x = 1; x < 11; x++ ) {
        std::vector<unsigned>::iterator i = std::find( seq.begin(), seq.end(), x );
        if( i != seq.end() ) {
            std::cout << std::setw( 3 ) << x << " is at pos. #" << 1 + distance( seq.begin(), i ) << "\n";
        }
    }

    std::cout << "\n";
    std::vector<unsigned>::iterator i = std::find( seq.begin(), seq.end(), 100 );
    if( i != seq.end() ) {
        std::cout << 100 << " is at pos. #" << 1 + distance( seq.begin(), i ) << "\n";
    }

    std::cout << "\n";
    unsigned g;
    bool f = false;
    for( int x = 0, y = 1; x < 1000; x++, y++ ) {
        g =  gcd( seq[x], seq[y] );
	if( g != 1 ) f = true;
        std::cout << std::setw( 4 ) << x + 1 << ": GCD (" << seq[x] << ", "
                  << seq[y] << ") = " << g << ( g != 1 ? " <-- ERROR\n" : "\n" );
    }
    std::cout << "\n" << ( f ? "THERE WERE ERRORS --- NOT ALL GCDs ARE '1'!" : "CORRECT: ALL GCDs ARE '1'!" ) << "\n\n";
    return 0;
}
