#include <windows.h>
#include <iostream>

//--------------------------------------------------------------------------------------------------
using namespace std;

//--------------------------------------------------------------------------------------------------
class fc_dealer
{
public:
    void deal( int game )
    {
	_gn = game;
	fillDeck();
	shuffle();
	display();
    }

private:
    void fillDeck()
    {
	int p = 0;
	for( int c = 0; c < 13; c++ )
	    for( int s = 0; s < 4; s++ )
		_cards[p++] = c | s << 4;
    }

    void shuffle()
    {
	srand( _gn );
	int cc = 52, nc, lc;
	while( cc )
	{
	    nc = rand() % cc;
	    lc = _cards[--cc];
	    _cards[cc] = _cards[nc];
	    _cards[nc] = lc;
	}
    }

    void display()
    {
	char* suit = "CDHS";
	char* symb = "A23456789TJQK";
	int z = 0;
	cout << "GAME #" << _gn << endl << "=======================" << endl;
	for( int c = 51; c >= 0; c-- )
	{
	    cout << symb[_cards[c] & 15] << suit[_cards[c] >> 4] << " ";
	    if( ++z >= 8 )
	    {
		cout << endl;
		z = 0;
	    }
	}
    }

    int _cards[52], _gn;
};
//--------------------------------------------------------------------------------------------------
int main( int argc, char* argv[] )
{
    fc_dealer dealer;
    int gn;
    while( true )
    {
	cout << endl << "Game number please ( 0 to QUIT ): "; cin >> gn;
	if( !gn ) break;

	system( "cls" );
	dealer.deal( gn );
	cout << endl << endl;
    }
    return 0;
}
//--------------------------------------------------------------------------------------------------
