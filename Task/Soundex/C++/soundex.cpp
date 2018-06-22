#include <iostream> // required for debug code in main() only
#include <iomanip>  // required for debug code in main() only
#include <string>

std::string soundex( char const* s )
{
    static char const code[] = { 0, -1,  1,  2,  3, -1,  1,  2,  0, -1,  2,  2,  4,  5,  5, -1,  1,  2,  6,  2,  3, -1,  1,  0,  2,  0,  2,  0,  0,  0,  0,  0 };

    if( !s || !*s )
        return std::string();

    std::string out( "0000" );
    out[0] = (*s >= 'a' && *s <= 'z') ? *s - ('a' - 'A') : *s;
    ++s;

    char prev = code[out[0] & 0x1F]; // first letter, though not coded, can still affect next letter: Pfister
    for( unsigned i = 1; *s && i < 4; ++s )
    {
        if( (*s & 0xC0) != 0x40 ) // process only letters in range [0x40 - 0x7F]
            continue;
        auto const c = code[*s & 0x1F];
        if( c == prev )
            continue;

        if( c == -1 )
            prev = 0;    // vowel as separator
        else if( c )
        {
            out[i] = c + '0';
            ++i;
            prev = c;
        }
    }
    return out;
}

int main()
{
    static char const * const names[][2] =
    {
        {"Ashcraft",    "A261"},
        {"Burroughs",   "B620"},
        {"Burrows",     "B620"},
        {"Ekzampul",    "E251"},
        {"Ellery",      "E460"},
        {"Euler",       "E460"},
        {"Example",     "E251"},
        {"Gauss",       "G200"},
        {"Ghosh",       "G200"},
        {"Gutierrez",   "G362"},
        {"Heilbronn",   "H416"},
        {"Hilbert",     "H416"},
        {"Jackson",     "J250"},
        {"Kant",        "K530"},
        {"Knuth",       "K530"},
        {"Ladd",        "L300"},
        {"Lee",         "L000"},
        {"Lissajous",   "L222"},
        {"Lloyd",       "L300"},
        {"Lukasiewicz", "L222"},
        {"O'Hara",      "O600"},
        {"Pfister",     "P236"},
        {"Soundex",     "S532"},
        {"Sownteks",    "S532"},
        {"Tymczak",     "T522"},
        {"VanDeusen",   "V532"},
        {"Washington",  "W252"},
        {"Wheaton",     "W350"}
    };

    for( auto const& name : names )
    {
        auto const sdx = soundex( name[0] );
        std::cout << std::left << std::setw( 16 ) << name[0] << std::setw( 8 ) << sdx << (sdx == name[1] ? " ok" : " ERROR") << std::endl;
    }
    return 0;
}
