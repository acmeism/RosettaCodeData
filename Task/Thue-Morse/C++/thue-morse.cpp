#include <iostream>
#include <iterator>
#include <vector>
int main( int argc, char* argv[] ) {
    std::vector<bool> t;
    t.push_back( 0 );
    size_t len = 1;
    std::cout << t[0] << "\n";
    do {
        for( size_t x = 0; x < len; x++ )
            t.push_back( t[x] ? 0 : 1 );
        std::copy( t.begin(), t.end(), std::ostream_iterator<bool>( std::cout ) );
        std::cout << "\n";
        len = t.size();
    } while( len < 60 );
    return 0;
}
