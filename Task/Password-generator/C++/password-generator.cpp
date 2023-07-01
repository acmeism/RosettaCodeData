#include <iostream>
#include <string>
#include <algorithm>
#include <ctime>

const std::string CHR[] = { "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz",
                            "0123456789", "!\"#$%&'()*+,-./:;<=>?@[]^_{|}~" };
const std::string UNS = "O0l1I5S2Z";

std::string createPW( int len, bool safe ) {
    std::string pw;
    char t;
    for( int x = 0; x < len; x += 4 ) {
        for( int y = x; y < x + 4 && y < len; y++ ) {
            do {
                t = CHR[y % 4].at( rand() % CHR[y % 4].size() );
            } while( safe && UNS.find( t ) != UNS.npos );
            pw.append( 1, t );
        }
    }
    std::random_shuffle( pw.begin(), pw.end() );
    return pw;
}
void generate( int len, int count, bool safe ) {
    for( int c = 0; c < count; c++ ) {
        std::cout << createPW( len, safe ) << "\n";
    }
    std::cout << "\n\n";
}
int main( int argc, char* argv[] ){
    if( argv[1][1] == '?' || argc < 5 ) {
        std::cout << "Syntax: PWGEN length count safe seed /?\n"
                     "length:\tthe length of the password(min 4)\n"
                     "count:\thow many passwords should be generated\n"
                     "safe:\t1 will exclude visually similar characters, 0 won't\n"
                     "seed:\tnumber to seed the random generator or 0\n"
                     "/?\tthis text\n\n";
    } else {
        int l = atoi( argv[1] ),
            c = atoi( argv[2] ),
            e = atoi( argv[3] ),
            s = atoi( argv[4] );
        if( l < 4 ) {
            std::cout << "Passwords must be at least 4 characters long.\n\n";
        } else {
            if (s == 0) {
               std::srand( time( NULL ) );
            } else {
               std::srand( unsigned( s ) );
            }
            generate( l, c, e != 0 );
        }
    }
    return 0;
}
