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
        dx[0] = -1; dy[0] =  0; dx[1] =  1; dy[1] =  0;
	dx[2] =  0; dy[2] = -1; dx[3] =  0; dy[3] =  1;
    }

    void solve( vector<string>& puzz, int max_wid )
    {
	if( puzz.size() < 1 ) return;
	wid = max_wid; hei = static_cast<int>( puzz.size() ) / wid;
	int len = wid * hei, c = 0; max = len;
	arr = new node[len]; memset( arr, 0, len * sizeof( node ) );
	weHave = new bool[len + 1]; memset( weHave, 0, len + 1 );

	for( vector<string>::iterator i = puzz.begin(); i != puzz.end(); i++ )
	{
	    if( ( *i ) == "*" ) { max--; arr[c++].val = -1; continue; }
	    arr[c].val = atoi( ( *i ).c_str() );
	    if( arr[c].val > 0 ) weHave[arr[c].val] = true;
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
	delete [] weHave;
    }

private:
    bool search( int x, int y, int w, int dr )
    {
	if( ( w > max && dr > 0 ) || ( w < 1 && dr < 0 ) || ( w == max && weHave[w] ) ) return true;

	node* n = &arr[x + y * wid];
	n->neighbors = getNeighbors( x, y );
	if( weHave[w] )
	{
	    for( int d = 0; d < 4; d++ )
	    {
		if( n->neighbors & ( 1 << d ) )
		{
		    int a = x + dx[d], b = y + dy[d];
		    if( arr[a + b * wid].val == w )
		    if( search( a, b, w + dr, dr ) ) return true;
		}
	    }
	    return false;
	}

	for( int d = 0; d < 4; d++ )
	{
	    if( n->neighbors & ( 1 << d ) )
	    {
		int a = x + dx[d], b = y + dy[d];
		if( arr[a + b * wid].val == 0 )
		{
		    arr[a + b * wid].val = w;
		    if( search( a, b, w + dr, dr ) ) return true;
		    arr[a + b * wid].val = 0;
		}
	    }
	}
	return false;
    }

    unsigned char getNeighbors( int x, int y )
    {
	unsigned char c = 0; int a, b;
	for( int xx = 0; xx < 4; xx++ )
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
	search( x, y, z + 1, 1 );
        if( z > 1 ) search( x, y, z - 1, -1 );
    }

    void findStart( int& x, int& y, int& z )
    {
        z = 99999;
	for( int b = 0; b < hei; b++ )
	    for( int a = 0; a < wid; a++ )
		if( arr[a + wid * b].val > 0 && arr[a + wid * b].val < z )
		{
		    x = a; y = b;
		    z = arr[a + wid * b].val;
		}

    }

    int wid, hei, max, dx[4], dy[4];
    node* arr;
    bool* weHave;
};
//------------------------------------------------------------------------------
int main( int argc, char* argv[] )
{
    int wid; string p;
    //p = ". . . . . . . . . . . 46 45 . 55 74 . . . 38 . . 43 . . 78 . . 35 . . . . . 71 . . . 33 . . . 59 . . . 17 . . . . . 67 . . 18 . . 11 . . 64 . . . 24 21 . 1  2 . . . . . . . . . . ."; wid = 9;
    //p = ". . . . . . . . . . 11 12 15 18 21 62 61 . .  6 . . . . . 60 . . 33 . . . . . 57 . . 32 . . . . . 56 . . 37 .  1 . . . 73 . . 38 . . . . . 72 . . 43 44 47 48 51 76 77 . . . . . . . . . ."; wid = 9;
    p = "17 . . . 11 . . . 59 . 15 . . 6 . . 61 . . . 3 . . .  63 . . . . . . 66 . . . . 23 24 . 68 67 78 . 54 55 . . . . 72 . . . . . . 35 . . . 49 . . . 29 . . 40 . . 47 . 31 . . . 39 . . . 45"; wid = 9;
	
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
