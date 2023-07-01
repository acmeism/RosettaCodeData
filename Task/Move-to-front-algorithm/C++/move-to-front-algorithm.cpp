#include <iostream>
#include <iterator>
#include <sstream>
#include <vector>

using namespace std;

class MTF
{
public:
    string encode( string str )
    {
	fillSymbolTable();
	vector<int> output;
	for( string::iterator it = str.begin(); it != str.end(); it++ )
	{
	    for( int i = 0; i < 26; i++ )
	    {
		if( *it == symbolTable[i] )
		{
		    output.push_back( i );
		    moveToFront( i );
		    break;
		}
	    }
	}
	string r;
	for( vector<int>::iterator it = output.begin(); it != output.end(); it++ )
	{
	    ostringstream ss;
	    ss << *it;
	    r += ss.str() + " ";
	}
	return r;
    }

    string decode( string str )
    {
	fillSymbolTable();
	istringstream iss( str ); vector<int> output;
	copy( istream_iterator<int>( iss ), istream_iterator<int>(), back_inserter<vector<int> >( output ) );
	string r;
	for( vector<int>::iterator it = output.begin(); it != output.end(); it++ )
	{
	    r.append( 1, symbolTable[*it] );
	    moveToFront( *it );
	}
	return r;
    }

private:
    void moveToFront( int i )
    {
	char t = symbolTable[i];
	for( int z = i - 1; z >= 0; z-- )
	    symbolTable[z + 1] = symbolTable[z];

        symbolTable[0] = t;
    }

    void fillSymbolTable()
    {
        for( int x = 0; x < 26; x++ )
	    symbolTable[x] = x + 'a';
    }

    char symbolTable[26];
};

int main()
{
    MTF mtf;
    string a, str[] = { "broood", "bananaaa", "hiphophiphop" };
    for( int x = 0; x < 3; x++ )
    {
        a = str[x];
        cout << a << " -> encoded = ";
        a = mtf.encode( a );
        cout << a << "; decoded = " << mtf.decode( a ) << endl;
    }
    return 0;
}
