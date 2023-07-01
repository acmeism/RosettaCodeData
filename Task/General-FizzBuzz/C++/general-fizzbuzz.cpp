#include <algorithm>
#include <iostream>
#include <vector>
#include <string>

class pair  {
public:
    pair( int s, std::string z )            { p = std::make_pair( s, z ); }
    bool operator < ( const pair& o ) const { return i() < o.i(); }
    int i() const                           { return p.first; }
    std::string s() const                   { return p.second; }
private:
    std::pair<int, std::string> p;
};
void gFizzBuzz( int c, std::vector<pair>& v ) {
    bool output;
    for( int x = 1; x <= c; x++ ) {
        output = false;
        for( std::vector<pair>::iterator i = v.begin(); i != v.end(); i++ ) {
            if( !( x % ( *i ).i() ) ) {
                std::cout << ( *i ).s();
                output = true;
            }
        }
        if( !output ) std::cout << x;
        std::cout << "\n";
    }
}
int main( int argc, char* argv[] ) {
    std::vector<pair> v;
    v.push_back( pair( 7, "Baxx" ) );
    v.push_back( pair( 3, "Fizz" ) );
    v.push_back( pair( 5, "Buzz" ) );
    std::sort( v.begin(), v.end() );
    gFizzBuzz( 20, v );
    return 0;
}
