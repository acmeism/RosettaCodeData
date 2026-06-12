#include <vector>
#include <iostream>
#include <fstream>
#include <sstream>

typedef struct {
    int s[4];
}userI;

class jit{
public:
    void decode( std::string& file, std::vector<userI>& ui ) {
        std::ifstream f( file.c_str(), std::ios_base::in );
        fileBuffer = std::string( ( std::istreambuf_iterator<char>( f ) ), std::istreambuf_iterator<char>() );
        f.close();
        for( std::vector<userI>::iterator t = ui.begin(); t != ui.end(); t++ ) {
            if( !decode( ( *t ).s ) ) break;
        }
        std::cout << "\n\n";
    }
private:
    bool decode( int* ui ) {
        int l = 0, t = 0, p = 0, c = 0, a = 0;
        for( std::string::iterator i = fileBuffer.begin(); i != fileBuffer.end(); i++ ) {
            if( p == ui[0] && l == ui[1] && t == ui[2] && c == ui[3] ) {
                if( *i == '!' )  return false;
                std::cout << *i; return true;
            }
            if( *i == '\n' )      { l++; t = c = 0; }
            else if( *i == '\t' ) { t++; c = 0; }
            else if( *i == '\f' ) { p++; l = t = c = 0; }
            else                  { c++;}
        }
        return false;
    }
    std::string fileBuffer;
};
void getUserInput( std::vector<userI>& u ) {
    std::string h = "0 18 0 0 0 68 0 1 0 100 0 32 0 114 0 45 0 38 0 26 0 16 0 21 0 17 0 59 0 11 "
                    "0 29 0 102 0 0 0 10 0 50 0 39 0 42 0 33 0 50 0 46 0 54 0 76 0 47 0 84 2 28";
    //std::getline( std::cin, h );
    std::stringstream ss( h );
    userI a;
    int x = 0;
    while( std::getline( ss, h, ' ' ) ) {
        a.s[x] = atoi( h.c_str() );
        if( ++x == 4 ) {
            u.push_back( a );
            x = 0;
        }
    }
}
int main( int argc, char* argv[] ) {
    std::vector<userI> ui;
    getUserInput( ui );

    jit j;
    j.decode( std::string( "theRaven.txt" ), ui );
    return 0;
}
