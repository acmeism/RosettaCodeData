#include <iostream>
#include <string>
#include <windows.h>
using namespace std;
typedef unsigned char byte;

enum fieldValues : byte { OPEN, CLOSED = 10, MINE, UNKNOWN, FLAG, ERR };

class fieldData
{
public:
    fieldData() : value( CLOSED ), open( false ) {}
    byte value;
    bool open, mine;
};

class game
{
public:
    ~game()
    { if( field ) delete [] field; }

    game( int x, int y )
    {
        go = false; wid = x; hei = y;
	field = new fieldData[x * y];
	memset( field, 0, x * y * sizeof( fieldData ) );
	oMines = ( ( 22 - rand() % 11 ) * x * y ) / 100;
	mMines = 0;
	int mx, my, m = 0;
	for( ; m < oMines; m++ )
	{
	    do
	    { mx = rand() % wid; my = rand() % hei; }
	    while( field[mx + wid * my].mine );
	    field[mx + wid * my].mine = true;
	}
	graphs[0] = ' '; graphs[1] = '.'; graphs[2] = '*';
	graphs[3] = '?'; graphs[4] = '!'; graphs[5] = 'X';
    }
	
    void gameLoop()
    {
	string c, r, a;
	int col, row;
	while( !go )
	{
	    drawBoard();
	    cout << "Enter column, row and an action( c r a ):\nActions: o => open, f => flag, ? => unknown\n";
	    cin >> c >> r >> a;
	    if( c[0] > 'Z' ) c[0] -= 32; if( a[0] > 'Z' ) a[0] -= 32;
	    col = c[0] - 65; row = r[0] - 49;
	    makeMove( col, row, a );
	}
    }

private:
    void makeMove( int x, int y, string a )
    {
	fieldData* fd = &field[wid * y + x];
	if( fd->open && fd->value < CLOSED )
	{
	    cout << "This cell is already open!";
	    Sleep( 3000 ); return;
	}
	if( a[0] == 'O' ) openCell( x, y );
	else if( a[0] == 'F' )
	{
	    fd->open = true;
	    fd->value = FLAG;
	    mMines++;
	    checkWin();
	}
	else
	{
	    fd->open = true;
	    fd->value = UNKNOWN;
	}
    }

    bool openCell( int x, int y )
    {
	if( !isInside( x, y ) ) return false;
	if( field[x + y * wid].mine ) boom();
	else
	{
	    if( field[x + y * wid].value == FLAG )
	    {
		field[x + y * wid].value = CLOSED;
		field[x + y * wid].open = false;
		mMines--;
	    }
	    recOpen( x, y );
	    checkWin();
	}
	return true;
    }

    void drawBoard()
    {
	system( "cls" );
	cout << "Marked mines: " << mMines << " from " << oMines << "\n\n";		
	for( int x = 0; x < wid; x++ )
	    cout << "  " << ( char )( 65 + x ) << " ";
	cout << "\n"; int yy;
	for( int y = 0; y < hei; y++ )
	{
	    yy = y * wid;
	    for( int x = 0; x < wid; x++ )
		cout << "+---";

	    cout << "+\n"; fieldData* fd;
	    for( int x = 0; x < wid; x++ )
	    {
		fd = &field[x + yy]; cout<< "| ";
		if( !fd->open ) cout << ( char )graphs[1] << " ";
		else
		{
		    if( fd->value > 9 )
			cout << ( char )graphs[fd->value - 9] << " ";
		    else
		    {
			if( fd->value < 1 ) cout << "  ";
			    else cout << ( char )(fd->value + 48 ) << " ";
		    }
		}
	    }
	    cout << "| " << y + 1 << "\n";
	}
	for( int x = 0; x < wid; x++ )
	    cout << "+---";

	cout << "+\n\n";
    }

    void checkWin()
    {
	int z = wid * hei - oMines, yy;
	fieldData* fd;
	for( int y = 0; y < hei; y++ )
	{
	    yy = wid * y;
	    for( int x = 0; x < wid; x++ )
	    {
		fd = &field[x + yy];
		if( fd->open && fd->value != FLAG ) z--;
	    }
	}
	if( !z ) lastMsg( "Congratulations, you won the game!");
    }

    void boom()
    {
	int yy; fieldData* fd;
	for( int y = 0; y < hei; y++ )
	{
	    yy = wid * y;
	    for( int x = 0; x < wid; x++ )
	    {
		fd = &field[x + yy];
		if( fd->value == FLAG )
		{
		    fd->open = true;
		    fd->value = fd->mine ? MINE : ERR;
		}
		else if( fd->mine )
		{
		    fd->open = true;
		    fd->value = MINE;
		}
	    }
	}
	lastMsg( "B O O O M M M M M !" );
    }

    void lastMsg( string s )
    {
	go = true; drawBoard();
	cout << s << "\n\n";
    }

    bool isInside( int x, int y ) { return ( x > -1 && y > -1 && x < wid && y < hei ); }

    void recOpen( int x, int y )
    {
	if( !isInside( x, y ) || field[x + y * wid].open ) return;
	int bc = getMineCount( x, y );
	field[x + y * wid].open = true;
	field[x + y * wid].value = bc;
	if( bc ) return;

	for( int yy = -1; yy < 2; yy++ )
	    for( int xx = -1; xx < 2; xx++ )
	    {
		if( xx == 0 && yy == 0 ) continue;
		recOpen( x + xx, y + yy );
	    }
    }

    int getMineCount( int x, int y )
    {
	int m = 0;
	for( int yy = -1; yy < 2; yy++ )
	    for( int xx = -1; xx < 2; xx++ )
	    {
		if( xx == 0 && yy == 0 ) continue;
		if( isInside( x + xx, y + yy ) && field[x + xx + ( y + yy ) * wid].mine ) m++;
	    }
		
	return m;
    }
	
    int wid, hei, mMines, oMines;
    fieldData* field; bool go;
    int graphs[6];
};

int main( int argc, char* argv[] )
{
    srand( GetTickCount() );
    game g( 4, 6 ); g.gameLoop();
    return system( "pause" );
}
