#include <iostream>
#include <string>
#include <map>
#include <vector>
#include <algorithm>

std::map<char, int> _map;
std::vector<std::string> _result;
size_t longest = 0;

void make_sequence( std::string n ) {
    _map.clear();
    for( std::string::iterator i = n.begin(); i != n.end(); i++ )
        _map.insert( std::make_pair( *i, _map[*i]++ ) );

    std::string z;
    for( std::map<char, int>::reverse_iterator i = _map.rbegin(); i != _map.rend(); i++ ) {
        char c = ( *i ).second + 48;
        z.append( 1, c );
        z.append( 1, i->first );
    }

    if( longest <= z.length() ) {
        longest = z.length();
        if( std::find( _result.begin(), _result.end(), z ) == _result.end() ) {
            _result.push_back( z );
            make_sequence( z );
        }
    }
}
int main( int argc, char* argv[] ) {
    std::vector<std::string> tests;
    tests.push_back( "9900" ); tests.push_back( "9090" ); tests.push_back( "9009" );
    for( std::vector<std::string>::iterator i = tests.begin(); i != tests.end(); i++ ) {
        make_sequence( *i );
        std::cout  << "[" << *i << "] Iterations: " << _result.size() + 1 << "\n";
        for( std::vector<std::string>::iterator j = _result.begin(); j != _result.end(); j++ ) {
            std::cout << *j << "\n";
        }
        std::cout << "\n\n";
    }
    return 0;
}
