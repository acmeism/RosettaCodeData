#include <iostream>
#include <iomanip>
#include <string>

class oo {
public:
    void evolve( int l, int rule ) {
        std::string    cells = "O";
        std::cout << " Rule #" << rule << ":\n";
        for( int x = 0; x < l; x++ ) {
            addNoCells( cells );
            std::cout << std::setw( 40 + ( static_cast<int>( cells.length() ) >> 1 ) ) << cells << "\n";
            step( cells, rule );
        }
    }
private:
    void step( std::string& cells, int rule ) {
        int bin;
        std::string newCells;
        for( size_t i = 0; i < cells.length() - 2; i++ ) {
            bin = 0;
            for( size_t n = i, b = 2; n < i + 3; n++, b >>= 1 ) {
                bin += ( ( cells[n] == 'O' ? 1 : 0 ) << b );
            }
            newCells.append( 1, rule & ( 1 << bin ) ? 'O' : '.' );
        }
        cells = newCells;
    }
    void addNoCells( std::string& s ) {
        char l = s.at( 0 ) == 'O' ? '.' : 'O',
             r = s.at( s.length() - 1 ) == 'O' ? '.' : 'O';
        s = l + s + r;
        s = l + s + r;
    }
};
int main( int argc, char* argv[] ) {
    oo o;
    o.evolve( 35, 90 );
    std::cout << "\n";
    return 0;
}
