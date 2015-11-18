#include <iostream>
#include <sstream>
#include <iterator>
#include <vector>
#include <cmath>

using namespace std;

class fractran
{
public:
    void run( std::string p, int s, int l  )
    {
        start = s; limit = l;
        istringstream iss( p ); vector<string> tmp;
        copy( istream_iterator<string>( iss ), istream_iterator<string>(), back_inserter<vector<string> >( tmp ) );

        string item; vector< pair<float, float> > v;
	pair<float, float> a;
	for( vector<string>::iterator i = tmp.begin(); i != tmp.end(); i++ )
	{
	    string::size_type pos = ( *i ).find( '/', 0 );
	    if( pos != std::string::npos )
	    {
		a = make_pair( atof( ( ( *i ).substr( 0, pos ) ).c_str() ), atof( ( ( *i ).substr( pos + 1 ) ).c_str() ) );
		v.push_back( a );
	    }
	}
		
	exec( &v );
    }

private:
    void exec( vector< pair<float, float> >* v )
    {
	int cnt = 0;
	while( cnt < limit )
	{
	    cout << cnt << " : " << start << "\n";
	    cnt++;
	    vector< pair<float, float> >::iterator it = v->begin();
	    bool found = false; float r;
	    while( it != v->end() )
	    {
		r  = start * ( ( *it ).first / ( *it ).second );
		if( r == floor( r ) )
		{
		    found = true;
		    break;
		}
		++it;
	    }

	    if( found ) start = ( int )r;
	    else break;
	}
    }
    int start, limit;
};
int main( int argc, char* argv[] )
{
    fractran f; f.run( "17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1", 2, 15 );
    cin.get();
    return 0;
}
