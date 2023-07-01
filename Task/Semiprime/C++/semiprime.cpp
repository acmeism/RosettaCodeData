#include <iostream>

bool isSemiPrime( int c )
{
    int a = 2, b = 0;
    while( b < 3 && c != 1 )
    {
	if( !( c % a ) )
	{ c /= a; b++; }
	else a++;
    }
    return b == 2;
}
int main( int argc, char* argv[] )
{
    for( int x = 2; x < 100; x++ )
	if( isSemiPrime( x ) )
	    std::cout << x << " ";

    return 0;
}
