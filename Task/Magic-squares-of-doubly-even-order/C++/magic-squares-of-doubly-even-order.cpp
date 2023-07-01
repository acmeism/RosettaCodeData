#include <iostream>
#include <sstream>
#include <iomanip>
using namespace std;

class magicSqr
{
public:
    magicSqr( int d ) {
        while( d % 4 > 0 ) { d++; }
        sz = d;
        sqr = new int[sz * sz];
        fillSqr();
    }
    ~magicSqr() { delete [] sqr; }

    void display() const {
        cout << "Doubly Even Magic Square: " << sz << " x " << sz << "\n";
        cout << "It's Magic Sum is: " << magicNumber() << "\n\n";
        ostringstream cvr; cvr << sz * sz;
        int l = cvr.str().size();

        for( int y = 0; y < sz; y++ ) {
            int yy = y * sz;
            for( int x = 0; x < sz; x++ ) {
                cout << setw( l + 2 ) << sqr[yy + x];
            }
            cout << "\n";
        }
        cout << "\n\n";
    }
private:
    void fillSqr() {
        static const bool tempAll[4][4] = {{ 1, 0, 0, 1 }, { 0, 1, 1, 0 }, { 0, 1, 1, 0 }, { 1, 0, 0, 1 } };
        int i = 0;
        for( int curRow = 0; curRow < sz; curRow++ ) {
            for( int curCol = 0; curCol < sz; curCol++ ) {
                sqr[curCol + sz * curRow] = tempAll[curRow % 4][curCol % 4] ? i + 1 : sz * sz - i;
                i++;
            }
        }
    }
    int magicNumber() const { return sz * ( ( sz * sz ) + 1 ) / 2; }

    int* sqr;
    int sz;
};

int main( int argc, char* argv[] ) {
    magicSqr s( 8 );
    s.display();
    return 0;
}
