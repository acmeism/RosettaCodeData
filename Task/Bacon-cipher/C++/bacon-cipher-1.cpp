#include <iostream>
#include <algorithm>
#include <vector>
#include <bitset>
#include <string>

class bacon {
public:
    bacon() {
        int x = 0;
        for( ; x < 9; x++ )
            bAlphabet.push_back( std::bitset<5>( x ).to_string() );
        bAlphabet.push_back( bAlphabet.back() );

        for( ; x < 20; x++ )
            bAlphabet.push_back( std::bitset<5>( x ).to_string() );
        bAlphabet.push_back( bAlphabet.back() );

        for( ; x < 24; x++ )
            bAlphabet.push_back( std::bitset<5>( x ).to_string() );
    }

    std::string encode( std::string txt ) {
        std::string r;
        size_t z;
        for( std::string::iterator i = txt.begin(); i != txt.end(); i++ ) {
            z = toupper( *i );
            if( z < 'A' || z > 'Z' ) continue;
            r.append( bAlphabet.at( ( *i & 31 ) - 1 ) );
        }
        return r;
    }

    std::string decode( std::string txt ) {
        size_t len = txt.length();
        while( len % 5 != 0 ) len--;
        if( len != txt.length() ) txt = txt.substr( 0, len );
        std::string r;
        for( size_t i = 0; i < len; i += 5 ) {
            r.append( 1, 'A' + std::distance( bAlphabet.begin(), std::find( bAlphabet.begin(), bAlphabet.end(), txt.substr( i, 5 ) ) ) );
        }
        return r;
    }

private:
    std::vector<std::string> bAlphabet;
};
