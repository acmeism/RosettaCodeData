#include <sstream> // for istringstream

using namespace std;

bool isNumeric( const char* pszInput, int nNumberBase )
{
	istringstream iss( pszInput );

	if ( nNumberBase == 10 )
	{
		double dTestSink;
		iss >> dTestSink;
	}
	else if ( nNumberBase == 8 || nNumberBase == 16 )
	{
		int nTestSink;
		iss >> ( ( nNumberBase == 8 ) ? oct : hex ) >> nTestSink;
	}
	else
		return false;

	// was any input successfully consumed/converted?
	if ( ! iss )
		return false;

	// was all the input successfully consumed/converted?
	return ( iss.rdbuf()->in_avail() == 0 );
}
