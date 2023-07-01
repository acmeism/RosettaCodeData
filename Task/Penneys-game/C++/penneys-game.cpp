#include <time.h>
#include <iostream>
#include <string>

using namespace std;

class penney
{
public:
    penney()
    { pW = cW = 0;  }
    void gameLoop()
    {
	string a;
	while( true )
	{
	    playerChoice = computerChoice = "";
	    if( rand() % 2 )
	    { computer(); player(); }
	    else
	    { player(); computer(); }

	    play();

	    cout << "[Y] to play again "; cin >> a;
	    if( a[0] != 'Y' && a[0] != 'y' )
	    {
		cout << "Computer won " << cW << " times." << endl << "Player won " << pW << " times.";
		break;
	    }
	    cout << endl << endl;
        }
    }
private:
    void computer()
    {
        if( playerChoice.length() == 0 )
	{
	    for( int x = 0; x < 3; x++ )
		computerChoice.append( ( rand() % 2 ) ? "H" : "T", 1 );	
	}
	else
	{
	    computerChoice.append( playerChoice[1] == 'T' ? "H" : "T", 1 );
	    computerChoice += playerChoice.substr( 0, 2 );
	}
	cout << "Computer's sequence of three is: " << computerChoice << endl;
    }
    void player()
    {
	cout << "Enter your sequence of three (H/T) "; cin >> playerChoice;
    }
    void play()
    {
	sequence = "";
	while( true )
	{
	    sequence.append( ( rand() % 2 ) ? "H" : "T", 1 );
	    if( sequence.find( playerChoice ) != sequence.npos )
	    {
		showWinner( 1 );
		break;
	    }
	    else if( sequence.find( computerChoice ) != sequence.npos )
	    {
		showWinner( 0 );
		break;
	    }
	}
    }
    void showWinner( int i )
    {
	string s;
	if( i ) { s = "Player wins!"; pW++; }
	else { s = "Computer wins!"; cW++; }
	cout << "Tossed sequence: " << sequence << endl << s << endl << endl;
    }
    string playerChoice, computerChoice, sequence;
    int pW, cW;
};
int main( int argc, char* argv[] )
{
    srand( static_cast<unsigned>( time( NULL ) ) );
    penney game; game.gameLoop();
    return 0;
}
