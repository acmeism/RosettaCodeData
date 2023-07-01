#include <algorithm>
#include <fstream>
#include <iostream>
#include <vector>
#include <string>

const std::string _CHARS = "abcdefghijklmnopqrstuvwxyz0123456789.:-_/";
const size_t MAX_NODES = 41;

class node
{
public:
    node() { clear(); }
    node( char z ) { clear(); }
    ~node() { for( int x = 0; x < MAX_NODES; x++ ) if( next[x] ) delete next[x]; }
    void clear() { for( int x = 0; x < MAX_NODES; x++ ) next[x] = 0; isWord = false; }
    bool isWord;
    std::vector<std::string> files;
    node* next[MAX_NODES];
};

class index {
public:
    void add( std::string s, std::string fileName ) {
        std::transform( s.begin(), s.end(), s.begin(), tolower );
        std::string h;
        for( std::string::iterator i = s.begin(); i != s.end(); i++ ) {
            if( *i == 32 ) {
                pushFileName( addWord( h ), fileName );
                h.clear();
                continue;
            }
            h.append( 1, *i );
        }
        if( h.length() )
            pushFileName( addWord( h ), fileName );
    }
    void findWord( std::string s ) {
        std::vector<std::string> v = find( s );
        if( !v.size() ) {
            std::cout << s + " was not found!\n";
            return;
        }
        std::cout << s << " found in:\n";
        for( std::vector<std::string>::iterator i = v.begin(); i != v.end(); i++ ) {
            std::cout << *i << "\n";
        }
        std::cout << "\n";
    }
private:
    void pushFileName( node* n, std::string fn ) {
        std::vector<std::string>::iterator i = std::find( n->files.begin(), n->files.end(), fn );
        if( i == n->files.end() ) n->files.push_back( fn );
    }
    const std::vector<std::string>& find( std::string s ) {
        size_t idx;
        std::transform( s.begin(), s.end(), s.begin(), tolower );
        node* rt = &root;
        for( std::string::iterator i = s.begin(); i != s.end(); i++ ) {
            idx = _CHARS.find( *i );
            if( idx < MAX_NODES ) {
                if( !rt->next[idx] ) return std::vector<std::string>();
                rt = rt->next[idx];
            }
        }
        if( rt->isWord ) return rt->files;
        return std::vector<std::string>();
    }
    node* addWord( std::string s ) {
        size_t idx;
        node* rt = &root, *n;
        for( std::string::iterator i = s.begin(); i != s.end(); i++ ) {
            idx = _CHARS.find( *i );
            if( idx < MAX_NODES ) {
                n = rt->next[idx];
                if( n ){
                    rt = n;
                    continue;
                }
                n = new node( *i );
                rt->next[idx] = n;
                rt = n;
            }
        }
        rt->isWord = true;
        return rt;
    }
    node root;
};
int main( int argc, char* argv[] ) {
    index t;
    std::string s;
    std::string files[] = { "file1.txt", "f_text.txt", "text_1b.txt" };

    for( int x = 0; x < 3; x++ ) {
        std::ifstream f;
        f.open( files[x].c_str(), std::ios::in );
        if( f.good() ) {
            while( !f.eof() ) {
                f >> s;
                t.add( s, files[x] );
                s.clear();
            }
            f.close();
        }
    }

    while( true ) {
        std::cout << "Enter one word to search for, return to exit: ";
        std::getline( std::cin, s );
        if( !s.length() ) break;
        t.findWord( s );

    }
    return 0;
}
