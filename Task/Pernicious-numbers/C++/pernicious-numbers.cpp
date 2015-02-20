#include <iostream>
#include <algorithm>
#include <bitset>

using namespace std;

class pernNumber
{
public:
    void displayFirst( unsigned cnt )
    {
	unsigned pn = 3;
	while( cnt )
	{
	    if( isPernNumber( pn ) )
	    {
		cout << pn << " "; cnt--;
	    }
	    pn++;
	}
    }
    void displayFromTo( unsigned a, unsigned b )
    {
	for( unsigned p = a; p <= b; p++ )
	    if( isPernNumber( p ) )
		cout << p << " ";
    }

private:
    bool isPernNumber( unsigned p )
    {
	string bin = bitset<64>( p ).to_string();
	unsigned c = count( bin.begin(), bin.end(), '1' );
	return isPrime( c );
    }
    bool isPrime( unsigned p )
    {
	if( p == 2 ) return true;
	if( p < 2 || !( p % 2 ) ) return false;
	for( unsigned x = 3; ( x * x ) <= p; x += 2 )
	    if( !( p % x ) ) return false;
	return true;
    }
};
int main( int argc, char* argv[] )
{
    pernNumber p;
    p.displayFirst( 25 ); cout << endl;
    p.displayFromTo( 888888877, 888888888 ); cout << endl;
    return 0;
}
