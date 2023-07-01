#include <iostream>

void leoN( int cnt, int l0 = 1, int l1 = 1, int add = 1 ) {
    int t;
    for( int i = 0; i < cnt; i++ ) {
        std::cout << l0 << " ";
        t = l0 + l1 + add; l0 = l1; l1 = t;
    }
}
int main( int argc, char* argv[] ) {
    std::cout << "Leonardo Numbers: "; leoN( 25 );
    std::cout << "\n\nFibonacci Numbers: "; leoN( 25, 0, 1, 0 );
    return 0;
}
