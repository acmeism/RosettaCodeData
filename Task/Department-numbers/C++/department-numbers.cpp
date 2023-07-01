#include <iostream>
#include <iomanip>

int main( int argc, char* argv[] ) {
    int sol = 1;
    std::cout << "\t\tFIRE\t\tPOLICE\t\tSANITATION\n";
    for( int f = 1; f < 8; f++ ) {
        for( int p = 1; p < 8; p++ ) {
            for( int s = 1; s < 8; s++ ) {
                if( f != p && f != s && p != s && !( p & 1 ) && ( f + s + p == 12 ) ) {
                std::cout << "SOLUTION #" << std::setw( 2 ) << sol++ << std::setw( 2 )
                << ":\t" << std::setw( 2 ) << f << "\t\t " << std::setw( 3 ) << p
                << "\t\t" << std::setw( 6 ) << s << "\n";
                }
            }
        }
    }
    return 0;
}
