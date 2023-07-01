#include <iostream>
#include <algorithm>
#include <ctime>
#include <string>
#include <vector>

typedef std::vector<char> vecChar;

class master {
public:
    master( size_t code_len, size_t clr_count, size_t guess_count, bool rpt ) {
        std::string color = "ABCDEFGHIJKLMNOPQRST";

        if( code_len < 4 ) code_len = 4; else if( code_len > 10 ) code_len = 10;
        if( !rpt && clr_count < code_len ) clr_count = code_len;
        if( clr_count < 2 ) clr_count = 2; else if( clr_count > 20 ) clr_count = 20;
        if( guess_count < 7 ) guess_count = 7; else if( guess_count > 20 ) guess_count = 20;

        codeLen = code_len; colorsCnt = clr_count; guessCnt = guess_count; repeatClr = rpt;

        for( size_t s = 0; s < colorsCnt; s++ ) {
            colors.append( 1, color.at( s ) );
        }
    }
    void play() {
        bool win = false;
        combo = getCombo();

        while( guessCnt ) {
            showBoard();
            if( checkInput( getInput() ) ) {
                win = true;
                break;
            }
            guessCnt--;
        }
        if( win ) {
            std::cout << "\n\n--------------------------------\n" <<
                "Very well done!\nYou found the code: " << combo <<
                "\n--------------------------------\n\n";
        } else {
            std::cout << "\n\n--------------------------------\n" <<
                "I am sorry, you couldn't make it!\nThe code was: " << combo <<
                "\n--------------------------------\n\n";
        }
    }
private:
    void showBoard() {
        vecChar::iterator y;
        for( int x = 0; x < guesses.size(); x++ ) {
            std::cout << "\n--------------------------------\n";
            std::cout << x + 1 << ": ";
            for( y = guesses[x].begin(); y != guesses[x].end(); y++ ) {
                std::cout << *y << " ";
            }

            std::cout << " :  ";
            for( y = results[x].begin(); y != results[x].end(); y++ ) {
                std::cout << *y << " ";
            }

            int z = codeLen - results[x].size();
            if( z > 0 ) {
                for( int x = 0; x < z; x++ ) std::cout << "- ";
            }
        }
        std::cout << "\n\n";
    }
    std::string getInput() {
        std::string a;
        while( true ) {
            std::cout << "Enter your guess (" << colors << "): ";
            a = ""; std::cin >> a;
            std::transform( a.begin(), a.end(), a.begin(), ::toupper );
            if( a.length() > codeLen ) a.erase( codeLen );
            bool r = true;
            for( std::string::iterator x = a.begin(); x != a.end(); x++ ) {
                if( colors.find( *x ) == std::string::npos ) {
                    r = false;
                    break;
                }
            }
            if( r ) break;
        }
        return a;
    }
    bool checkInput( std::string a ) {
        vecChar g;
        for( std::string::iterator x = a.begin(); x != a.end(); x++ ) {
            g.push_back( *x );
        }
        guesses.push_back( g );

        int black = 0, white = 0;
        std::vector<bool> gmatch( codeLen, false );
        std::vector<bool> cmatch( codeLen, false );

        for( int i = 0; i < codeLen; i++ ) {
            if( a.at( i ) == combo.at( i ) ) {
                gmatch[i] = true;
                cmatch[i] = true;
                black++;
            }
        }

        for( int i = 0; i < codeLen; i++ ) {
            if (gmatch[i]) continue;
            for( int j = 0; j < codeLen; j++ ) {
                if (i == j || cmatch[j]) continue;
                if( a.at( i ) == combo.at( j ) ) {
                    cmatch[j] = true;
                    white++;
                    break;
                }
            }
        }

        vecChar r;
        for( int b = 0; b < black; b++ ) r.push_back( 'X' );
        for( int w = 0; w < white; w++ ) r.push_back( 'O' );
        results.push_back( r );

        return ( black == codeLen );
    }
    std::string getCombo() {
        std::string c, clr = colors;
        int l, z;

        for( size_t s = 0; s < codeLen; s++ ) {
            z = rand() % ( int )clr.length();
            c.append( 1, clr[z] );
            if( !repeatClr ) clr.erase( z, 1 );
        }
        return c;
    }

    size_t codeLen, colorsCnt, guessCnt;
    bool repeatClr;
    std::vector<vecChar> guesses, results;
    std::string colors, combo;
};

int main( int argc, char* argv[] ) {
    srand( unsigned( time( 0 ) ) );
    master m( 4, 8, 12, false );
    m.play();
    return 0;
}
