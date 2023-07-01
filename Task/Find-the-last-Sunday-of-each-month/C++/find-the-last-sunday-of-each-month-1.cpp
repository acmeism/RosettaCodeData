#include <windows.h>
#include <iostream>
#include <string>

//--------------------------------------------------------------------------------------------------
using namespace std;

//--------------------------------------------------------------------------------------------------
class lastSunday
{
public:
    lastSunday()
    {
	m[0]  = "JANUARY:   "; m[1]  = "FEBRUARY:  "; m[2]  = "MARCH:     "; m[3]  = "APRIL:     ";
	m[4]  = "MAY:       "; m[5]  = "JUNE:      "; m[6]  = "JULY:      "; m[7]  = "AUGUST:    ";
	m[8]  = "SEPTEMBER: "; m[9]  = "OCTOBER:   "; m[10] = "NOVEMBER:  "; m[11] = "DECEMBER:  ";
    }

    void findLastSunday( int y )
    {
	year = y;
	isleapyear();

	int days[] = { 31, isleap ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 },
		d;
	for( int i = 0; i < 12; i++ )
	{
	    d = days[i];
	    while( true )
	    {
		if( !getWeekDay( i, d ) ) break;
		d--;
	    }
	    lastDay[i] = d;
	}

	display();
    }

private:
    void isleapyear()
    {
	isleap = false;
	if( !( year % 4 ) )
	{
	    if( year % 100 ) isleap = true;
	    else if( !( year % 400 ) ) isleap = true;
	}
    }

    void display()
    {
	system( "cls" );
	cout << "  YEAR " << year << endl << "=============" << endl;
	for( int x = 0; x < 12; x++ )
	    cout << m[x] << lastDay[x] << endl;

	cout << endl << endl;
    }

    int getWeekDay( int m, int d )
    {
	int y = year;

	int f = y + d + 3 * m - 1;
	m++;
	if( m < 3 ) y--;
	else f -= int( .4 * m + 2.3 );

	f += int( y / 4 ) - int( ( y / 100 + 1 ) * 0.75 );
	f %= 7;

	return f;
    }

    int lastDay[12], year;
    string m[12];
    bool isleap;
};
//--------------------------------------------------------------------------------------------------
int main( int argc, char* argv[] )
{
    int y;
    lastSunday ls;

    while( true )
    {
	system( "cls" );
	cout << "Enter the year( yyyy ) --- ( 0 to quit ): ";
	cin >> y;
	if( !y ) return 0;

	ls.findLastSunday( y );

	system( "pause" );
    }
    return 0;
}
//--------------------------------------------------------------------------------------------------
