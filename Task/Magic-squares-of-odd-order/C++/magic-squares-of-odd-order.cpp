#include <iostream>
#include <sstream>
#include <iomanip>
using namespace std;

class magicSqr
{
public:
    magicSqr() { sqr = 0; }
    ~magicSqr() { if( sqr ) delete [] sqr; }

    void create( int d )
    {
        if( sqr ) delete [] sqr;
        if( !( d & 1 ) ) d++; sz = d;
        sqr = new int[sz * sz];
        memset( sqr, 0, sz * sz * sizeof( int ) );
        fillSqr();
    }

    void display()
    {
        cout << "Odd Magic Square: " << sz << " x " << sz << "\n";
        cout << "It's Magic Sum is: " << magicNumber() << "\n\n";
        ostringstream cvr; cvr << sz * sz;
        int l = cvr.str().size();

	for( int y = 0; y < sz; y++ )
	{
	    int yy = y * sz;
	    for( int x = 0; x < sz; x++ )
		cout << setw( l + 2 ) << sqr[yy + x];

	    cout << "\n";
	}
        cout << "\n\n";
    }

private:
    void fillSqr()
    {
	int sx = sz / 2, sy = 0, c = 0;
	while( c < sz * sz )
	{
	    if( !sqr[sx + sy * sz] )
	    {
		sqr[sx + sy * sz]= c + 1;
		inc( sx ); dec( sy );
		c++;
	    }
	    else
	    {
		dec( sx ); inc( sy ); inc( sy );
	    }
	}
    }

    int magicNumber()
    { return ( ( ( sz * sz + 1 ) / 2 ) * sz ); }

    void inc( int& a )
    { if( ++a == sz ) a = 0; }

    void dec( int& a )
    { if( --a < 0 ) a = sz - 1; }

    bool checkPos( int x, int y )
    { return( isInside( x ) && isInside( y ) && !sqr[sz * y + x] ); }

    bool isInside( int s )
    { return ( s < sz && s > -1 ); }

    int* sqr;
    int sz;
};

int main( int argc, char* argv[] )
{
    magicSqr s;
    s.create( 5 );
    s.display();
    return system( "pause" );
}
