#include <time.h>
#include <iostream>
#include <string>

typedef unsigned char byte;
using namespace std;

class flip
{
public:
    flip() { field = 0; target = 0; }
    void play( int w, int h ) { wid = w; hei = h; createField(); gameLoop(); }

private:
    void gameLoop()
    {
	int moves = 0;
	while( !solved() )
	{
	    display(); string r; cout << "Enter rows letters and/or column numbers: "; cin >> r;
	    for( string::iterator i = r.begin(); i != r.end(); i++ )
	    {
		byte ii = ( *i );
		if( ii - 1 >= '0' && ii - 1 <= '9' ) { flipCol( ii - '1' ); moves++; }
		else if( ii >= 'a' && ii <= 'z' ) { flipRow( ii - 'a' ); moves++; }
	    }
	}
	cout << endl << endl << "** Well done! **" << endl << "Used " << moves << " moves." << endl << endl;
    }

    void display()
    { system( "cls" ); output( "TARGET:", target ); output( "YOU:", field ); }

    void output( string t, byte* f )
    {
	cout << t << endl;
	cout << " "; for( int x = 0; x < wid; x++ ) cout << " " << static_cast<char>( x + '1' ); cout << endl;
	for( int y = 0; y < hei; y++ )
	{
	    cout << static_cast<char>( y + 'a' ) << " ";
	    for( int x = 0; x < wid; x++ )
		cout << static_cast<char>( f[x + y * wid] + 48 ) << " ";
	    cout << endl;
	}
	cout << endl << endl;
    }

    bool solved()
    {
	for( int y = 0; y < hei; y++ )
	    for( int x = 0; x < wid; x++ )
		if( target[x + y * wid] != field[x + y * wid] ) return false;
	return true;
    }

    void createTarget()
    {
	for( int y = 0; y < hei; y++ )
	    for( int x = 0; x < wid; x++ )
		if( frnd() < .5f ) target[x + y * wid] = 1;
	        else target[x + y * wid] = 0;
	memcpy( field, target, wid * hei );
    }

    void flipCol( int c )
    { for( int x = 0; x < hei; x++ ) field[c + x * wid] = !field[c + x * wid]; }
	
    void flipRow( int r )
    { for( int x = 0; x < wid; x++ ) field[x + r * wid] = !field[x + r * wid]; }

    void calcStartPos()
    {
	int flips = ( rand() % wid + wid + rand() % hei + hei ) >> 1;
	for( int x = 0; x < flips; x++ )
	{ if( frnd() < .5f ) flipCol( rand() % wid ); else flipRow( rand() % hei ); }
    }

    void createField()
    {
        if( field ){ delete [] field; delete [] target; }
        int t = wid * hei; field = new byte[t]; target = new byte[t];
	memset( field, 0, t ); memset( target, 0, t ); createTarget();
	while( true ) { calcStartPos(); if( !solved() ) break; }
    }

    float frnd() { return static_cast<float>( rand() ) / static_cast<float>( RAND_MAX ); }

    byte* field, *target; int wid, hei;
};

int main( int argc, char* argv[] )
{ srand( time( NULL ) ); flip g; g.play( 3, 3 ); return system( "pause" ); }
