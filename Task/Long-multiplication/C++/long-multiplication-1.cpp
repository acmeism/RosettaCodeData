#include <iostream>
#include <sstream>
//--------------------------------------------------------------------------------------------------
typedef long long bigInt;
//--------------------------------------------------------------------------------------------------
using namespace std;
//--------------------------------------------------------------------------------------------------
class number
{
public:
    number()                                { s = "0"; neg = false; }
    number( bigInt a )                      { set( a ); }
    number( string a )                      { set( a ); }
    void set( bigInt a )                    { neg = false; if( a < 0 ) { a = -a; neg = true; } ostringstream o; o << a; s = o.str(); clearStr(); }
    void set( string a )                    { neg = false; s = a; if( s.length() > 1 && s[0] == '-' ) { neg = true; } clearStr(); }
    number operator *  ( const number& b )  { return this->mul( b ); }
    number& operator *= ( const number& b ) { *this = *this * b; return *this; }
    number& operator = ( const number& b )  { s = b.s; return *this; }
    friend ostream& operator << ( ostream& out, const number& a ) { if( a.neg ) out << "-"; out << a.s; return out; }
    friend istream& operator >> ( istream& in, number& a ){ string b; in >> b; a.set( b ); return in; }

private:
    number mul( const number& b )
    {
	number a; bool neg = false;
	string r, bs = b.s; r.resize( 2 * max( b.s.length(), s.length() ), '0' );
	int xx, ss, rr, t, c, stp = 0;
	string::reverse_iterator xi = bs.rbegin(), si, ri;
	for( ; xi != bs.rend(); xi++ )
	{
	    c = 0; ri = r.rbegin() + stp;
	    for( si = s.rbegin(); si != s.rend(); si++ )
	    {
		xx = ( *xi ) - 48; ss = ( *si ) - 48; rr = ( *ri ) - 48;
		ss = ss * xx + rr + c; t = ss % 10; c = ( ss - t ) / 10;
		( *ri++ ) = t + 48;
	    }
	    if( c > 0 ) ( *ri ) = c + 48;
	    stp++;
	}
	trimLeft( r ); t = b.neg ? 1 : 0; t += neg ? 1 : 0;
	if( t & 1 ) a.s = "-" + r;
	else a.s = r;
	return a;
    }

    void trimLeft( string& r )
    {
	if( r.length() < 2 ) return;
	for( string::iterator x = r.begin(); x != ( r.end() - 1 ); )
	{
	    if( ( *x ) != '0' ) return;
	    x = r.erase( x );
	}
    }

    void clearStr()
    {
	for( string::iterator x = s.begin(); x != s.end(); )
	{
	    if( ( *x ) < '0' || ( *x ) > '9' ) x = s.erase( x );
	    else x++;
	}
    }
    string s;
    bool neg;
};
//--------------------------------------------------------------------------------------------------
int main( int argc, char* argv[] )
{
    number a, b;
    a.set( "18446744073709551616" ); b.set( "18446744073709551616" );
    cout << a * b << endl << endl;

    cout << "Factor 1 = "; cin >> a;
    cout << "Factor 2 = "; cin >> b;
    cout << "Product: = " << a * b << endl << endl;
    return system( "pause" );
}
//--------------------------------------------------------------------------------------------------
