#include <ctime>
#include <string>
#include <iostream>
#include <algorithm>

class cycle{
public:
    template <class T>
    void cy( T* a, int len ) {
        int i, j;
        show( "original: ", a, len );
        std::srand( unsigned( time( 0 ) ) );

        for( int i = len - 1; i > 0; i-- ) {
            do {
                j = std::rand() % i;
            } while( j >= i );
            std::swap( a[i], a[j] );
        }

        show( "  cycled: ", a, len ); std::cout << "\n";
    }
private:
    template <class T>
    void show( std::string s, T* a, int len ) {
        std::cout << s;
        for( int i = 0; i < len; i++ ) {
            std::cout << a[i] << " ";
        }
        std::cout << "\n";
    }
};
int main( int argc, char* argv[] ) {
    std::string d0[] = { "" },
                d1[] = { "10" },
                d2[] = { "10", "20" };
    int         d3[] = { 10, 20, 30 },
                d4[] = { 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 };
    cycle c;
    c.cy( d0, sizeof( d0 ) / sizeof( d0[0] ) );
    c.cy( d1, sizeof( d1 ) / sizeof( d1[0] ) );
    c.cy( d2, sizeof( d2 ) / sizeof( d2[0] ) );
    c.cy( d3, sizeof( d3 ) / sizeof( d3[0] ) );
    c.cy( d4, sizeof( d4 ) / sizeof( d4[0] ) );

    return 0;
}
