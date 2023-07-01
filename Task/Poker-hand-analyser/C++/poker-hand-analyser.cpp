#include <iostream>
#include <sstream>
#include <algorithm>
#include <vector>

using namespace std;

class poker
{
public:
    poker() { face = "A23456789TJQK"; suit = "SHCD"; }
    string analyze( string h )
    {
	memset( faceCnt, 0, 13 ); memset( suitCnt, 0, 4 ); vector<string> hand;
	transform( h.begin(), h.end(), h.begin(), toupper ); istringstream i( h );
	copy( istream_iterator<string>( i ), istream_iterator<string>(), back_inserter<vector<string> >( hand ) );
	if( hand.size() != 5 ) return "invalid hand."; vector<string>::iterator it = hand.begin();
	sort( it, hand.end() ); if( hand.end() != adjacent_find( it, hand.end() ) ) return "invalid hand.";
	while( it != hand.end() )
	{
	    if( ( *it ).length() != 2 ) return "invalid hand.";
	    int n = face.find( ( *it ).at( 0 ) ), l = suit.find( ( *it ).at( 1 ) );
	    if( n < 0 || l < 0 ) return "invalid hand.";
	    faceCnt[n]++; suitCnt[l]++; it++;
	}
	cout << h << ": "; return analyzeHand();
    }
private:
    string analyzeHand()
    {
	bool p1 = false, p2 = false, t = false, f = false, fl = false, st = false;
	for( int x = 0; x < 13; x++ )
	    switch( faceCnt[x] )
	    {
		case 2: if( p1 ) p2 = true; else p1 = true; break;
		case 3: t = true; break;
		case 4: f = true;
	    }
	for( int x = 0; x < 4; x++ )if( suitCnt[x] == 5 ){ fl = true; break; }

	if( !p1 && !p2 && !t && !f )
        {
	    int s = 0;
	    for( int x = 0; x < 13; x++ )
	    {
		if( faceCnt[x] ) s++; else s = 0;
		if( s == 5 ) break;
	    }
	    st = ( s == 5 ) || ( s == 4 && faceCnt[0] && !faceCnt[1] );
	}

	if( st && fl ) return "straight-flush";
	else if( f ) return "four-of-a-kind";
	else if( p1 && t ) return "full-house";
	else if( fl ) return "flush";
	else if( st ) return "straight";
	else if( t ) return "three-of-a-kind";
	else if( p1 && p2 ) return "two-pair";
	else if( p1 ) return "one-pair";
        return "high-card";
    }
    string face, suit;
    unsigned char faceCnt[13], suitCnt[4];
};

int main( int argc, char* argv[] )
{
    poker p;
    cout << p.analyze( "2h 2d 2s ks qd" ) << endl; cout << p.analyze( "2h 5h 7d 8s 9d" ) << endl;
    cout << p.analyze( "ah 2d 3s 4s 5s" ) << endl; cout << p.analyze( "2h 3h 2d 3s 3d" ) << endl;
    cout << p.analyze( "2h 7h 2d 3s 3d" ) << endl; cout << p.analyze( "2h 7h 7d 7s 7c" ) << endl;
    cout << p.analyze( "th jh qh kh ah" ) << endl; cout << p.analyze( "4h 4c kc 5d tc" ) << endl;
    cout << p.analyze( "qc tc 7c 6c 4c" ) << endl << endl; return system( "pause" );
}
