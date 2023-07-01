#include <iostream>

//--------------------------------------------------------------------------------------------------
typedef unsigned long long bigInt;

using namespace std;
//--------------------------------------------------------------------------------------------------
class m35
{
public:
    void doIt( bigInt i )
    {
	bigInt sum = 0;
	for( bigInt a = 1; a < i; a++ )
	    if( !( a % 3 ) || !( a % 5 ) ) sum += a;

	cout << "Sum is " << sum << " for n = " << i << endl << endl;
    }
	
    // this method uses less than half iterations than the first one
    void doIt_b( bigInt i )
    {
	bigInt sum = 0;
	for( bigInt a = 0; a < 28; a++ )
	{
	    if( !( a % 3 ) || !( a % 5 ) )
	    {
		sum += a;
		for( bigInt s = 30; s < i; s += 30 )
		    if( a + s < i ) sum += ( a + s );

	    }
	}
	cout << "Sum is " << sum << " for n = " << i << endl << endl;
    }
};
//--------------------------------------------------------------------------------------------------
int main( int argc, char* argv[] )
{
    m35 m; m.doIt( 1000 );
    return system( "pause" );
}
