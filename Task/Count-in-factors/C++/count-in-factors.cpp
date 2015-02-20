#include <iostream>
#include <sstream>
#include <iomanip>
using namespace std;

void getPrimeFactors( int li )
{
    int f = 2; string res;
    if( li == 1 ) res = "1";
    else
    {
	while( true )
	{
	    if( !( li % f ) )
	    {
		stringstream ss; ss << f;
		res += ss.str();
		li /= f; if( li == 1 ) break;
		res += " x ";
	    }
	    else f++;
	}
    }
    cout << res << "\n";
}

int main( int argc, char* argv[] )
{
    for( int x = 1; x < 101; x++ )
    {
	cout << right << setw( 4 ) << x << ": ";
	getPrimeFactors( x );
    }
    cout << 2144 << ": "; getPrimeFactors( 2144 );
    cout << "\n\n";
    return system( "pause" );
}
