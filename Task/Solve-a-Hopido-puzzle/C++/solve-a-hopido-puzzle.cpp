#include <vector>
#include <sstream>
#include <iostream>
#include <iterator>
#include <stdlib.h>
#include <string.h>

using namespace std;

struct node
{
    int val;
    unsigned char neighbors;
};

class nSolver
{
public:
    nSolver()
    {
	dx[0] = -2; dy[0] = -2; dx[1] = -2; dy[1] =  2;
	dx[2] =  2; dy[2] = -2; dx[3] =  2; dy[3] =  2;
	dx[4] = -3; dy[4] =  0; dx[5] =  3; dy[5] =  0;
	dx[6] =  0; dy[6] = -3; dx[7] =  0; dy[7] =  3;
    }

    void solve( vector<string>& puzz, int max_wid )
    {
	if( puzz.size() < 1 ) return;
	wid = max_wid; hei = static_cast<int>( puzz.size() ) / wid;
	int len = wid * hei, c = 0; max = len;
	arr = new node[len]; memset( arr, 0, len * sizeof( node ) );

	for( vector<string>::iterator i = puzz.begin(); i != puzz.end(); i++ )
	{
	    if( ( *i ) == "*" ) { max--; arr[c++].val = -1; continue; }
	    arr[c].val = atoi( ( *i ).c_str() );
	    c++;
	}

	solveIt(); c = 0;
	for( vector<string>::iterator i = puzz.begin(); i != puzz.end(); i++ )
	{
	    if( ( *i ) == "." )
	    {
		ostringstream o; o << arr[c].val;
		( *i ) = o.str();
	    }
	    c++;
	}
	delete [] arr;
    }

private:
    bool search( int x, int y, int w )
    {
	if( w > max ) return true;

	node* n = &arr[x + y * wid];
	n->neighbors = getNeighbors( x, y );

	for( int d = 0; d < 8; d++ )
	{
	    if( n->neighbors & ( 1 << d ) )
	    {
		int a = x + dx[d], b = y + dy[d];
		if( arr[a + b * wid].val == 0 )
		{
		    arr[a + b * wid].val = w;
		    if( search( a, b, w + 1 ) ) return true;
		    arr[a + b * wid].val = 0;
		}
	    }
	}
	return false;
    }

    unsigned char getNeighbors( int x, int y )
    {
	unsigned char c = 0; int a, b;
	for( int xx = 0; xx < 8; xx++ )
	{
	    a = x + dx[xx], b = y + dy[xx];
	    if( a < 0 || b < 0 || a >= wid || b >= hei ) continue;
	    if( arr[a + b * wid].val > -1 ) c |= ( 1 << xx );
	}
	return c;
    }

    void solveIt()
    {
	int x, y, z; findStart( x, y, z );
	if( z == 99999 ) { cout << "\nCan't find start point!\n"; return; }
	search( x, y, z + 1 );
    }

    void findStart( int& x, int& y, int& z )
    {
	for( int b = 0; b < hei; b++ )
	    for( int a = 0; a < wid; a++ )
		if( arr[a + wid * b].val == 0 )
		{
		    x = a; y = b; z = 1;
		    arr[a + wid * b].val = z;
		    return;
		}
    }

    int wid, hei, max, dx[8], dy[8];
    node* arr;
};

int main( int argc, char* argv[] )
{
    int wid; string p;
    p = "* . . * . . * . . . . . . . . . . . . . . * . . . . . * * * . . . * * * * * . * * *"; wid = 7;
    istringstream iss( p ); vector<string> puzz;
    copy( istream_iterator<string>( iss ), istream_iterator<string>(), back_inserter<vector<string> >( puzz ) );
    nSolver s; s.solve( puzz, wid );
    int c = 0;
    for( vector<string>::iterator i = puzz.begin(); i != puzz.end(); i++ )
    {
	if( ( *i ) != "*" && ( *i ) != "." )
	{
	    if( atoi( ( *i ).c_str() ) < 10 ) cout << "0";
	    cout << ( *i ) << " ";
	}
	else cout << "   ";
	if( ++c >= wid ) { cout << endl; c = 0; }
    }
    cout << endl << endl;
    return system( "pause" );
}
