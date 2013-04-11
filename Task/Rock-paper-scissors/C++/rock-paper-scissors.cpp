#include <windows.h>
#include <iostream>
#include <string>

//-------------------------------------------------------------------------------
using namespace std;

//-------------------------------------------------------------------------------
enum choices { ROCK, PAPER, SCISSORS };
enum indexes { PLAYER, COMPUTER, DRAW };

//-------------------------------------------------------------------------------
class stats
{
public:
    stats() : _draw( 0 )
    {
	ZeroMemory( _moves, sizeof( _moves ) );
	ZeroMemory( _win, sizeof( _win ) );
    }
    void draw()		        { _draw++; }
    void win( int p )	        { _win[p]++; }
    void move( int p, int m )   { _moves[p][m]++; }
    int getMove( int p, int m ) { return _moves[p][m]; }
    void print()
    {
	char t[256];
	wsprintf( t, "%.4d", _draw ); string d( t );

	wsprintf( t, "%.4d", _win[PLAYER] ); string pw( t );
	wsprintf( t, "%.4d", _moves[PLAYER][ROCK] ); string pr( t );
	wsprintf( t, "%.4d", _moves[PLAYER][PAPER] ); string pp( t );
	wsprintf( t, "%.4d", _moves[PLAYER][SCISSORS] ); string ps( t );

	wsprintf( t, "%.4d", _win[COMPUTER] ); string cw( t );
	wsprintf( t, "%.4d", _moves[COMPUTER][ROCK] ); string cr( t );
	wsprintf( t, "%.4d", _moves[COMPUTER][PAPER] ); string cp( t );
	wsprintf( t, "%.4d", _moves[COMPUTER][SCISSORS] ); string cs( t );

	system( "cls" );
	cout << endl;
	cout << "+--------------+----------+----------+----------+----------+----------+" << endl;
	cout << "|              |   WON    |   DRAW   |   ROCK   |  PAPER   | SCISSORS |" << endl;
	cout << "+--------------+----------+----------+----------+----------+----------+" << endl;
	cout << "|    PLAYER    |   "  << pw << "   |          |   " << pr;
	cout << "   |   " << pp << "   |   " << ps << "   |" << endl;
	cout << "+--------------+----------+   " << d << "   +----------+----------+----------+" << endl;
	cout << "|   COMPUTER   |   " << cw << "   |          |   " << cr;
	cout << "   |   " << cp << "   |   " << cs << "   |" << endl;
	cout << "+--------------+----------+----------+----------+----------+----------+" << endl;
	cout << endl << endl;

	system( "pause" );

    }

private:
    int _moves[2][3], _win[2], _draw;
};
//-------------------------------------------------------------------------------
class rps
{
private:
    int makeMove()
    {
	int total = 0, r, s;
	for( int i = 0; i < 3; total += statistics.getMove( PLAYER, i++ ) );
	r = rand() % total;
	s = statistics.getMove( PLAYER, ROCK );
	if( r < s ) return PAPER;
	if( r - s < statistics.getMove( PLAYER, PAPER ) ) return SCISSORS;
	return ROCK;
    }

    int checkWinner( int p, int m )
    {
	if( p == ROCK )
	{
	    switch( m )
	    {
		case PAPER: return COMPUTER;
		case SCISSORS: return PLAYER;
                default: return DRAW;
	    }
	}
	if( p == PAPER )
	{
	    switch( m )
	    {
		case SCISSORS: return COMPUTER;
		case ROCK: return PLAYER;
                default: return DRAW;
	    }
	}
	if( p == SCISSORS )
	{
	    switch( m )
	    {
		case ROCK: return COMPUTER;
		case PAPER: return PLAYER;
                default: return DRAW;
	    }
	}
	return DRAW;
    }

    void printMove( int p, int m )
    {
        string ms = "";
	switch( m )
	{
	    case 0: ms = "ROCK"; break;
	    case 1: ms = "PAPER"; break;
	    case 2: ms = "SCISSORS"; break;
	}

	if( p == COMPUTER ) cout << "My move: ";
	else cout << "Your move: ";
	cout << ms << endl;
    }

public:
    void play()
    {
	int p, r, m;
	while( true )
	{
	    cout << "What is your move (1)ROCK (2)PAPER (3)SCISSORS (0)Quit ? ";
	    cin >> p;
	    if( !p || p < 0 ) break;
	    if( p > 0 && p < 4 )
	    {
		p--;
		cout << endl;
		printMove( PLAYER, p );
		statistics.move( PLAYER, p );

		m = makeMove();
		statistics.move( COMPUTER, m );
		printMove( COMPUTER, m );

		r = checkWinner( p, m );
		switch( r )
		{
		    case DRAW:
			cout << endl << "DRAW!" << endl << endl;
			statistics.draw();

		    break;
		    case COMPUTER:
			cout << endl << "I WIN!" << endl << endl;
			statistics.win( COMPUTER );

		    break;
		    case PLAYER:
		        cout << endl << "YOU WIN!" << endl << endl;
		        statistics.win( PLAYER );

		}
	        system( "pause" );
	    }
	    system( "cls" );
	}

        statistics.print();
    }

private:
    stats statistics;
};
//-------------------------------------------------------------------------------
int main( int argc, char* argv[] )
{
    srand( GetTickCount() );
    rps game;
    game.play();
    return 0;
}
//-------------------------------------------------------------------------------
