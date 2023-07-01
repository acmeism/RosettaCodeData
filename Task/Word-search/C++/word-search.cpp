#include <iomanip>
#include <ctime>
#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <fstream>

const int WID = 10, HEI = 10, MIN_WORD_LEN = 3, MIN_WORD_CNT = 25;

class Cell {
public:
    Cell() : val( 0 ), cntOverlap( 0 ) {}
    char val; int cntOverlap;
};
class Word {
public:
    Word( std::string s, int cs, int rs, int ce, int re, int dc, int dr ) :
      word( s ), cols( cs ), rows( rs ), cole( ce ), rowe( re ), dx( dc ), dy( dr ) {}
    bool operator ==( const std::string& s ) { return 0 == word.compare( s ); }
    std::string word;
    int cols, rows, cole, rowe, dx, dy;
};
class words {
public:
    void create( std::string& file ) {
        std::ifstream f( file.c_str(), std::ios_base::in );
        std::string word;
        while( f >> word ) {
            if( word.length() < MIN_WORD_LEN || word.length() > WID || word.length() > HEI ) continue;
            if( word.find_first_not_of( "abcdefghijklmnopqrstuvwxyz" ) != word.npos ) continue;
            dictionary.push_back( word );
        }
        f.close();
        std::random_shuffle( dictionary.begin(), dictionary.end() );
        buildPuzzle();
    }

    void printOut() {
        std::cout << "\t";
        for( int x = 0; x < WID; x++ ) std::cout << x << "  ";
        std::cout << "\n\n";
        for( int y = 0; y < HEI; y++ ) {
            std::cout << y << "\t";
            for( int x = 0; x < WID; x++ )
                std::cout << puzzle[x][y].val << "  ";
            std::cout << "\n";
        }
        size_t wid1 = 0, wid2 = 0;
        for( size_t x = 0; x < used.size(); x++ ) {
            if( x & 1 ) {
                if( used[x].word.length() > wid1 ) wid1 = used[x].word.length();
            } else {
                if( used[x].word.length() > wid2 ) wid2 = used[x].word.length();
            }
        }
        std::cout << "\n";
        std::vector<Word>::iterator w = used.begin();
        while( w != used.end() ) {
            std::cout << std::right << std::setw( wid1 ) << ( *w ).word << " (" << ( *w ).cols << ", " << ( *w ).rows << ") ("
                      << ( *w ).cole << ", " << ( *w ).rowe << ")\t";
            w++;
            if( w == used.end() ) break;
            std::cout << std::setw( wid2 ) << ( *w ).word << " (" << ( *w ).cols << ", " << ( *w ).rows << ") ("
                      << ( *w ).cole << ", " << ( *w ).rowe << ")\n";
            w++;
        }
        std::cout << "\n\n";
    }
private:
    void addMsg() {
        std::string msg = "ROSETTACODE";
        int stp = 9, p = rand() % stp;
        for( size_t x = 0; x < msg.length(); x++ ) {
            puzzle[p % WID][p / HEI].val = msg.at( x );
            p += rand() % stp + 4;
        }
    }
    int getEmptySpaces() {
        int es = 0;
        for( int y = 0; y < HEI; y++ ) {
            for( int x = 0; x < WID; x++ ) {
                if( !puzzle[x][y].val ) es++;
            }
        }
        return es;
    }
    bool check( std::string word, int c, int r, int dc, int dr ) {
        for( size_t a = 0; a < word.length(); a++ ) {
            if( c < 0 || r < 0 || c >= WID || r >= HEI ) return false;
            if( puzzle[c][r].val && puzzle[c][r].val != word.at( a ) ) return false;
            c += dc; r += dr;
        }
        return true;
    }
    bool setWord( std::string word, int c, int r, int dc, int dr ) {
        if( !check( word, c, r, dc, dr ) ) return false;
        int sx = c, sy = r;
        for( size_t a = 0; a < word.length(); a++ ) {
            if( !puzzle[c][r].val ) puzzle[c][r].val = word.at( a );
            else puzzle[c][r].cntOverlap++;
            c += dc; r += dr;
        }
        used.push_back( Word( word, sx, sy, c - dc, r - dr, dc, dr ) );
        return true;
    }
    bool add2Puzzle( std::string word ) {
        int x = rand() % WID, y = rand() % HEI,
            z = rand() % 8;
        for( int d = z; d < z + 8; d++ ) {
            switch( d % 8 ) {
                case 0: if( setWord( word, x, y,  1,  0 ) ) return true; break;
                case 1: if( setWord( word, x, y, -1, -1 ) ) return true; break;
                case 2: if( setWord( word, x, y,  0,  1 ) ) return true; break;
                case 3: if( setWord( word, x, y,  1, -1 ) ) return true; break;
                case 4: if( setWord( word, x, y, -1,  0 ) ) return true; break;
                case 5: if( setWord( word, x, y, -1,  1 ) ) return true; break;
                case 6: if( setWord( word, x, y,  0, -1 ) ) return true; break;
                case 7: if( setWord( word, x, y,  1,  1 ) ) return true; break;
            }
        }
        return false;
    }
    void clearWord() {
        if( used.size() ) {
            Word lastW = used.back();
            used.pop_back();

            for( size_t a = 0; a < lastW.word.length(); a++ ) {
                if( puzzle[lastW.cols][lastW.rows].cntOverlap == 0 ) {
                    puzzle[lastW.cols][lastW.rows].val = 0;
                }
                if( puzzle[lastW.cols][lastW.rows].cntOverlap > 0 ) {
                    puzzle[lastW.cols][lastW.rows].cntOverlap--;
                }
                lastW.cols += lastW.dx; lastW.rows += lastW.dy;
            }
        }
    }
    void buildPuzzle() {
        addMsg();
        int es = 0, cnt = 0;
        size_t idx = 0;
        do {
            for( std::vector<std::string>::iterator w = dictionary.begin(); w != dictionary.end(); w++ ) {
                if( std::find( used.begin(), used.end(), *w ) != used.end() ) continue;

                if( add2Puzzle( *w ) ) {
                    es = getEmptySpaces();
                    if( !es && used.size() >= MIN_WORD_CNT )
                        return;
                }
            }
            clearWord();
            std::random_shuffle( dictionary.begin(), dictionary.end() );

        } while( ++cnt < 100 );
    }
    std::vector<Word> used;
    std::vector<std::string> dictionary;
    Cell puzzle[WID][HEI];
};
int main( int argc, char* argv[] ) {
    unsigned s = unsigned( time( 0 ) );
    srand( s );
    words w; w.create( std::string( "unixdict.txt" ) );
    w.printOut();
    return 0;
}
