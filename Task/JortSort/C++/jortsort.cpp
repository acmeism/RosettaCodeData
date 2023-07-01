#include <algorithm>
#include <string>
#include <iostream>
#include <iterator>

class jortSort {
public:
    template<class T>
    bool jort_sort( T* o, size_t s ) {
        T* n = copy_array( o, s );
        sort_array( n, s );
        bool r = false;

        if( n ) {
            r = check( o, n, s );
            delete [] n;
        }
        return r;
    }

private:
    template<class T>
    T* copy_array( T* o, size_t s ) {
        T* z = new T[s];
        memcpy( z, o, s * sizeof( T ) );
        //std::copy( o, o + s, z );
        return z;
    }
    template<class T>
    void sort_array( T* n, size_t s ) {
        std::sort( n, n + s );
    }
    template<class T>
    bool check( T* n, T* o, size_t s ) {
        for( size_t x = 0; x < s; x++ )
            if( n[x] != o[x] ) return false;
        return true;
    }
};

jortSort js;

template<class T>
void displayTest( T* o, size_t s ) {
    std::copy( o, o + s, std::ostream_iterator<T>( std::cout, " " ) );
    std::cout << ": -> The array is " << ( js.jort_sort( o, s ) ? "sorted!" : "not sorted!" ) << "\n\n";
}

int main( int argc, char* argv[] ) {
    const size_t s = 5;
    std::string oStr[] = { "5", "A", "D", "R", "S" };
    displayTest( oStr, s );
    std::swap( oStr[0], oStr[1] );
    displayTest( oStr, s );

    int oInt[] = { 1, 2, 3, 4, 5 };
    displayTest( oInt, s );
    std::swap( oInt[0], oInt[1] );
    displayTest( oInt, s );

    return 0;
}
