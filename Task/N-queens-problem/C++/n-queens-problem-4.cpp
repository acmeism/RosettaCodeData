#include <windows.h>
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

//--------------------------------------------------------------------------------------------------
using namespace std;

//--------------------------------------------------------------------------------------------------
typedef unsigned int uint;

//--------------------------------------------------------------------------------------------------
class nQueens_Heuristic
{
public:
    void solve( uint n ) { makeList( n ); drawBoard( n ); }

private:
    void drawBoard( uint n )
    {
	system( "cls" ); string t = "+---+", q = "| Q |", s = "|   |";
	COORD c = { 0, 0 }; HANDLE h = GetStdHandle( STD_OUTPUT_HANDLE );
	uint w = 0;
	for( uint y = 0, cy = 0; y < n; y++ )
	{
	    for( uint x = 0; x < n; x++ )
	    {
		SetConsoleCursorPosition( h, c ); cout << t;
		c.Y++; SetConsoleCursorPosition( h, c );
		if( x + 1 == solution[w] ) cout << q; else cout << s;
		c.Y++; SetConsoleCursorPosition( h, c );
		cout << t; c.Y = cy; c.X += 4;
	    }
	    cy += 2; c.X = 0; c.Y = cy; w++;
	}
	solution.clear(); odd.clear(); evn.clear();
    }

    void makeList( uint n )
    {
	uint r = n % 6;
	for( uint x = 1; x <= n; x++ )
	{
	    if( x & 1 ) odd.push_back( x );
	    else evn.push_back( x );
	}
	if( r == 2 )
	{
	    swap( odd[0], odd[1] );
	    odd.erase( find( odd.begin(), odd.end(), 5 ) );
	    odd.push_back( 5 );
	}
	else if( r == 3 )
	{
	    odd.erase( odd.begin() ); odd.erase( odd.begin() );
	    odd.push_back( 1 ); odd.push_back( 3 );
	    evn.erase( evn.begin() ); evn.push_back( 2 );
	}
	vector<uint>::iterator it = evn.begin();
	while( it != evn.end() )
	{
	    solution.push_back( ( *it ) );
	    it++;
	}
	it = odd.begin();
	while( it != odd.end() )
	{
	    solution.push_back( ( *it ) );
	    it++;
	}
    }

    vector<uint> odd, evn, solution;
};
//--------------------------------------------------------------------------------------------------
int main( int argc, char* argv[] )
{
    uint n; nQueens_Heuristic nQH;
    while( true )
    {
	cout << "Enter board size bigger than 3 (0 - 3 to QUIT): "; cin >> n;
	if( n < 4 ) return 0;
	nQH.solve( n ); cout << endl << endl;
    }
    return 0;
}
//--------------------------------------------------------------------------------------------------
