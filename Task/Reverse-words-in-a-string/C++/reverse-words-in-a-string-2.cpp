#include <string>
#include <iostream>
using namespace std;

string invertString( string s )
{
    string st, tmp;
    for( string::iterator it = s.begin(); it != s.end(); it++ )
    {
        if( *it != 32 ) tmp += *it;
        else
        {
            st = " " + tmp + st;
            tmp.clear();
        }
    }
    return tmp + st;
}

int main( int argc, char* argv[] )
{
    string str[] =
    {
        "---------- Ice and Fire ------------",
        "",
        "fire, in end will world the say Some",
        "ice. in say Some",
        "desire of tasted I've what From",
        "fire. favor who those with hold I",
        "",
        "... elided paragraph last ...",
        "",
        "Frost Robert -----------------------"
    };
    for( int i = 0; i < 10; i++ )
        cout << invertString( str[i] ) << "\n";

    cout << "\n";
    return system( "pause" );
}
