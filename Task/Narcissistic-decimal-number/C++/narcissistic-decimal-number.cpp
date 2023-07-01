#include <iostream>
#include <vector>
using namespace std;
typedef unsigned int uint;

class NarcissisticDecs
{
public:
    void makeList( int mx )
    {
	uint st = 0, tl; int pwr = 0, len;
        while( narc.size() < mx )
	{
	    len = getDigs( st );
	    if( pwr != len )
	    {
		pwr = len;
		fillPower( pwr );
	    }
            tl = 0;
	    for( int i = 1; i < 10; i++ )
		tl += static_cast<uint>( powr[i] * digs[i] );

	    if( tl == st ) narc.push_back( st );
	    st++;
	}
    }

    void display()
    {
	for( vector<uint>::iterator i = narc.begin(); i != narc.end(); i++ )
	    cout << *i << " ";
	cout << "\n\n";
    }

private:
    int getDigs( uint st )
    {
	memset( digs, 0, 10 * sizeof( int ) );
	int r = 0;
	while( st )
	{
	    digs[st % 10]++;
	    st /= 10;
	    r++;
	}
        return r;
    }

    void fillPower( int z )
    {
	for( int i = 1; i < 10; i++ )
	    powr[i] = pow( static_cast<float>( i ), z );
    }

    vector<uint> narc;
    uint powr[10];
    int digs[10];
};

int main( int argc, char* argv[] )
{
    NarcissisticDecs n;
    n.makeList( 25 );
    n.display();
    return system( "pause" );
}
