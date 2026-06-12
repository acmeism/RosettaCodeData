#include <iostream>   // required for debug code in main() only
#include <iomanip>    // required for debug code in main() only
#include <string>
#include <cstring>

std::string NYSIIS( std::string const& str )
{
    std::string s, out;
    s.reserve( str.length() );
    for( auto const c : str )
    {
        if( c >= 'a' && c <= 'z' )
            s += c - ('a' - 'A');
        else if( c >= 'A' && c <= 'Z' )
            s += c;
    }

    auto replace = []( char const * const from, char const* to, char* const dst ) -> bool
    {
        auto const n = strlen( from );
        if( strncmp( from, dst, n ) == 0 )
        {
            strncpy( dst, to, n );
            return true;
        }
        return false;
    };

    auto multiReplace = []( char const* const* from, char const* to, char* const dst ) -> bool
    {
        auto const n = strlen( *from );
        for( ; *from; ++from )
            if( strncmp( *from, dst, n ) == 0 )
            {
                memcpy( dst, to, n );
                return true;
            }
        return false;
    };

    auto isVowel = []( char const c ) -> bool
    {
        return c == 'A' || c == 'E' || c == 'I' || c == 'O' || c == 'U';
    };

    size_t n = s.length();
    replace( "MAC", "MCC", &s[0] );
    replace( "KN", "NN", &s[0] );
    replace( "K", "C", &s[0] );
    char const* const prefix[] = { "PH", "PF", 0 };
    multiReplace( prefix, "FF", &s[0] );
    replace( "SCH", "SSS", &s[0] );

    char const* const suffix1[] = { "EE", "IE", 0 };
    char const* const suffix2[] = { "DT", "RT", "RD", "NT", "ND", 0 };
    if( multiReplace( suffix1, "Y", &s[n - 2] ) || multiReplace( suffix2, "D", &s[n - 2] ))
    {
        s.pop_back();
        --n;
    }

    out += s[0];

    char* vowels[] = { "A", "E", "I", "O", "U", 0 };
    for( unsigned i = 1; i < n; ++i )
    {
        char* const c = &s[i];
        if( !replace( "EV", "AV", c ) )
            multiReplace( vowels, "A", c );
        replace( "Q", "G", c );
        replace( "Z", "S", c );
        replace( "M", "N", c );
        if( !replace( "KN", "NN", c ))
            replace( "K", "C", c );
        replace( "SCH", "SSS", c );
        replace( "PH", "FF", c );
        if( *c == 'H' && (!isVowel( s[i - 1] ) || i + 1 >= n || !isVowel( s[i + 1] )))
            *c = s[i - 1];
        if( *c == 'W' && isVowel( s[i - 1] ))
            *c = 'A';
        if( out.back() != *c )
            out += *c;
    }

    if( out.back() == 'S')
        out.pop_back();
    n = out.length() - 2;
    if( out[n] == 'A' && out[n + 1] == 'Y' )
        out = out.substr( 0, n ) + "Y";
    if( out.back() == 'A' )
        out.pop_back();
    return out;
}

int main()
{
    static char const * const names[][2] = {
    { "Bishop", "BASAP" },
    { "Carlson", "CARLSAN" },
    { "Carr", "CAR" },
    { "Chapman", "CAPNAN" },
    { "Franklin", "FRANCLAN" },
    { "Greene", "GRAN" },
    { "Harper", "HARPAR" },
    { "Jacobs", "JACAB" },
    { "Larson", "LARSAN" },
    { "Lawrence", "LARANC" },
    { "Lawson", "LASAN" },
    { "Louis, XVI", "LASXV" },
    { "Lynch", "LYNC" },
    { "Mackenzie", "MCANSY" },
    { "Matthews", "MAT" },
    { "McCormack", "MCARNAC" },
    { "McDaniel", "MCDANAL" },
    { "McDonald", "MCDANALD" },
    { "Mclaughlin", "MCLAGLAN" },
    { "Morrison", "MARASAN" },
    { "O'Banion", "OBANAN" },
    { "O'Brien", "OBRAN" },
    { "Richards", "RACARD" },
    { "Silva", "SALV" },
    { "Watkins", "WATCAN" },
    { "Wheeler", "WALAR" },
    { "Willis", "WAL" },
    { "brown, sr", "BRANSR" },
    { "browne, III", "BRAN" },
    { "browne, IV", "BRANAV" },
    { "knight", "NAGT" },
    { "mitchell", "MATCAL" },
    { "o'daniel", "ODANAL" } };

    for( auto const& name : names )
    {
        auto const code = NYSIIS( name[0] );
        std::cout << std::left << std::setw( 16 ) << name[0] << std::setw( 8 ) << code;
        if( code == std::string( name[1] ))
            std::cout << " ok";
        else
            std::cout << " ERROR: " << name[1] << " expected";
        std::cout << std::endl;
    }

    return 0;
}
