#include <iomanip>
#include <map>
#include <vector>
#include <iostream>
using namespace std;

void calcMDR( int n, int c, int& a, int& b )
{
    int m = n % 10; n /= 10;
    while( n )
    {
	m *= ( n % 10 );
	n /= 10;
    }
    if( m >= 10 ) calcMDR( m, ++c, a, b );
    else { a = m; b = c; }
}

void table()
{
    map<int, vector<int> > mp;
    int n = 0, a, b;
    bool f = true;
    while( f )
    {
	f = false;
	calcMDR( n, 1, a, b );
	mp[a].push_back( n );
	n++;
	for( int x = 0; x < 10; x++ )
	    if( mp[x].size() < 5 )
	    { f = true; break; }
    }

    cout << "|  MDR  |  [n0..n4]\n+-------+------------------------------------+\n";
    for( int x = 0; x < 10; x++ )
    {
	cout << right << "| " << setw( 6 ) << x << "| ";
	for( vector<int>::iterator i = mp[x].begin(); i != mp[x].begin() + 5; i++ )
	    cout << setw( 6 ) << *i << " ";
	cout << "|\n";
    }
    cout << "+-------+------------------------------------+\n\n";
}

int main( int argc, char* argv[] )
{
    cout << "|  NUMBER  |   MDR    |    MP    |\n+----------+----------+----------+\n";
    int numbers[] = { 123321, 7739, 893, 899998 }, a, b;
    for( int x = 0; x < 4; x++ )
    {
	cout << right << "| "  << setw( 9 ) << numbers[x] << "| ";
	calcMDR( numbers[x], 1, a, b );
	cout << setw( 9 ) << a  << "| " << setw( 9 ) << b << "|\n";
    }
    cout << "+----------+----------+----------+\n\n";
    table();
    return system( "pause" );
}
