#include <iostream>
#include <algorithm>
#include <vector>

int pShuffle( int t ) {
    std::vector<int> v, o, r;

    for( int x = 0; x < t; x++ ) {
        o.push_back( x + 1 );
    }

    r = o;
    int t2 = t / 2 - 1, c = 1;

    while( true ) {
        v = r;
        r.clear();

        for( int x = t2; x > -1; x-- ) {
            r.push_back( v[x + t2 + 1] );
            r.push_back( v[x] );
        }

        std::reverse( r.begin(), r.end() );

        if( std::equal( o.begin(), o.end(), r.begin() ) ) return c;
        c++;
    }
}

int main() {
    int s[] = { 8, 24, 52, 100, 1020, 1024, 10000 };
    for( int x = 0; x < 7; x++ ) {
        std::cout << "Cards count: " << s[x] << ", shuffles required: ";
        std::cout << pShuffle( s[x] ) << ".\n";
    }
    return 0;
}
