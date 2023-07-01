#include <string>
#include <algorithm>
#include <iostream>
#include <set>
#include <vector>

auto collectSubStrings( const std::string& s, int maxSubLength )
{
    int l = s.length();
    auto res = std::set<std::string>();
    for ( int start = 0; start < l; start++ )
    {
        int m = std::min( maxSubLength, l - start + 1 );
        for ( int length = 1; length < m; length++ )
        {
            res.insert( s.substr( start, length ) );
        }
    }
    return res;
}

std::string lcs( const std::string& s0, const std::string& s1 )
{
    // collect substring set
    auto maxSubLength = std::min( s0.length(), s1.length() );
    auto set0 = collectSubStrings( s0, maxSubLength );
    auto set1 = collectSubStrings( s1, maxSubLength );

    // get commons into a vector
    auto common = std::vector<std::string>();
    std::set_intersection( set0.begin(), set0.end(), set1.begin(), set1.end(),
        std::back_inserter( common ) );

    // get the longest one
    std::nth_element( common.begin(), common.begin(), common.end(),
        []( const std::string& s1, const std::string& s2 ) {
            return s1.length() > s2.length();
        } );
    return *common.begin();
}

int main( int argc, char* argv[] )
{
    auto s1 = std::string( "thisisatest" );
    auto s2 = std::string( "testing123testing" );
    std::cout << "The longest common substring of " << s1 << " and " << s2
              << " is:\n";
    std::cout << "\"" << lcs( s1, s2 ) << "\" !\n";
    return 0;
}
