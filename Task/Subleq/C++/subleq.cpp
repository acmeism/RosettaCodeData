#include <fstream>
#include <iostream>
#include <iterator>
#include <vector>

class subleq {
public:
    void load_and_run( std::string file ) {
        std::ifstream f( file.c_str(), std::ios_base::in );
        std::istream_iterator<int> i_v, i_f( f );
        std::copy( i_f, i_v, std::back_inserter( memory ) );
        f.close();
        run();
    }

private:
    void run() {
        int pc = 0, next, a, b, c;
        char z;
        do {
            next = pc + 3;
            a = memory[pc]; b = memory[pc + 1]; c = memory[pc + 2];
            if( a == -1 ) {
                std::cin >> z; memory[b] = static_cast<int>( z );
            } else if( b == -1 ) {
                std::cout << static_cast<char>( memory[a] );
            } else {
                memory[b] -= memory[a];
                if( memory[b] <= 0 ) next = c;
            }
            pc = next;
        } while( pc >= 0 );
    }

    std::vector<int> memory;
};

int main( int argc, char* argv[] ) {
    subleq s;
    if( argc > 1 ) {
        s.load_and_run( argv[1] );
    } else {
        std::cout << "usage: subleq <filename>\n";
    }
    return 0;
}
