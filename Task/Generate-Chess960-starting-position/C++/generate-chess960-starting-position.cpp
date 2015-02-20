#include <iostream>
#include <string>
#include <time.h>
using namespace std;
class chess960
{
public:
    void generate( int c )
    {
	for( int x = 0; x < c; x++ )
	    cout << startPos() << "\n";
    }

private:
    string startPos()
    {
	char p[8]; memset( p, 0, 8 );
	int b1, b2; bool q;

	// bishops
	while( 1 )
	{
	    b1 = rand() % 8; b2 = rand() % 8;
	    if( !( b1 & 1 ) && b2 & 1 ) break;
	}
	p[b1] = 'B'; p[b2] = 'B';

	// queen, knight, knight
	q = false;
	for( int x = 0; x < 3; x++ )
	{
	    do
	    { b1 = rand() % 8; }
	    while( p[b1] );
	    if( !q )
	    { p[b1] = 'Q'; q = true; }
	    else p[b1] = 'N';
	}

	// rook king rook
	q = false;
	for( int x = 0; x < 3; x++ )
	{
	    int a = 0;
	    for( ; a < 8; a++ )
		if( !p[a] ) break;

	    if( !q )
	    { p[a] = 'R'; q = true; }
	    else
	    { p[a] = 'K'; q = false; }
	}

	string s;
	for( int x = 0; x < 8; x++ )
	    s.append( 1, p[x] );

	return s;
    }
};

int main( int argc, char* argv[] )
{
    srand( time( NULL ) );
    chess960 c;
    c.generate( 10 );
    cout << "\n\n";
    return system( "pause" );
}
