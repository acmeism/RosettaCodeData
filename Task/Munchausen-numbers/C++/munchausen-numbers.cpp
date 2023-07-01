#include <math.h>
#include <iostream>

unsigned pwr[10];

unsigned munch( unsigned i ) {
    unsigned sum = 0;
    while( i ) {
        sum += pwr[(i % 10)];
        i /= 10;
    }
    return sum;
}

int main( int argc, char* argv[] ) {
    for( int i = 0; i < 10; i++ )
        pwr[i] = (unsigned)pow( (float)i, (float)i );
    std::cout << "Munchausen Numbers\n==================\n";
    for( unsigned i = 1; i < 5000; i++ )
        if( i == munch( i ) ) std::cout << i << "\n";
    return 0;
}
