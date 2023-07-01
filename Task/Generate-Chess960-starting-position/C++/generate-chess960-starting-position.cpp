#include <iostream>
#include <string>
#include <time.h>
using namespace std;

namespace
{
    void placeRandomly(char* p, char c)
    {
	int loc = rand() % 8;
	if (!p[loc])
	    p[loc] = c;
	else
	    placeRandomly(p, c);    // try again
    }
    int placeFirst(char* p, char c, int loc = 0)
    {
	while (p[loc]) ++loc;
	p[loc] = c;
        return loc;
    }

    string startPos()
    {
	char p[8]; memset( p, 0, 8 );

	// bishops on opposite color
	p[2 * (rand() % 4)] = 'B';
	p[2 * (rand() % 4) + 1] = 'B';

	// queen knight knight, anywhere
	for (char c : "QNN")
	    placeRandomly(p, c);

	// rook king rook, in that order
	placeFirst(p, 'R', placeFirst(p, 'K', placeFirst(p, 'R')));

	return string(p, 8);
    }
}   // leave local

namespace chess960
{
    void generate( int c )
    {
	for( int x = 0; x < c; x++ )
	    cout << startPos() << "\n";
    }
}

int main( int argc, char* argv[] )
{
    srand( time( NULL ) );
    chess960::generate( 10 );
    cout << "\n\n";
    return system( "pause" );
}
