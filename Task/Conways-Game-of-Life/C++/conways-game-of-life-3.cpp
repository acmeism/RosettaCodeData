#include <algorithm>
#include <vector>
#include <iostream>
#include <string>

typedef unsigned char byte;

class world {
public:
    world( int x, int y ) : _wid( x ), _hei( y ) {
        int s = _wid * _hei * sizeof( byte );
        _cells = new byte[s];
        memset( _cells, 0, s );
    }
    ~world() {
        delete [] _cells;
    }
    int wid() const {
        return _wid;
    }
    int hei() const {
        return _hei;
    }
    byte at( int x, int y ) const {
        return _cells[x + y * _wid];
    }
    void set( int x, int y, byte c ) {
        _cells[x + y * _wid] = c;
    }
    void swap( world* w ) {
        memcpy( _cells, w->_cells, _wid * _hei * sizeof( byte ) );
    }
private:
    int _wid, _hei;
    byte* _cells;
};
class rule {
public:
    rule( world* w ) : wrd( w ) {
        wid = wrd->wid();
        hei = wrd->hei();
        wrdT = new world( wid, hei );
    }
    ~rule() {
        if( wrdT ) delete wrdT;
    }
    bool hasLivingCells() {
        for( int y = 0; y < hei; y++ )
            for( int x = 0; x < wid; x++ )
                if( wrd->at( x, y ) ) return true;
        std::cout << "*** All cells are dead!!! ***\n\n";
        return false;
    }
    void swapWrds() {
        wrd->swap( wrdT );
    }
    void setRuleB( std::vector<int>& birth ) {
        _birth = birth;
    }
    void setRuleS( std::vector<int>& stay ) {
        _stay = stay;
    }
    void applyRules() {
        int n;
        for( int y = 0; y < hei; y++ ) {
            for( int x = 0; x < wid; x++ ) {
                n = neighbours( x, y );
                if( wrd->at( x, y ) ) {
                    wrdT->set( x, y, inStay( n ) ? 1 : 0 );
                } else {
                    wrdT->set( x, y, inBirth( n ) ? 1 : 0 );
                }
            }
        }
    }
private:
    int neighbours( int xx, int yy ) {
        int n = 0, nx, ny;
        for( int y = -1; y < 2; y++ ) {
            for( int x = -1; x < 2; x++ ) {
                if( !x && !y ) continue;
                nx = ( wid + xx + x ) % wid;
                ny = ( hei + yy + y ) % hei;
                n += wrd->at( nx, ny ) > 0 ? 1 : 0;
            }
        }
        return n;
    }
    bool inStay( int n ) {
        return( _stay.end() != find( _stay.begin(), _stay.end(), n ) );
    }
    bool inBirth( int n ) {
        return( _birth.end() != find( _birth.begin(), _birth.end(), n ) );
    }
    int wid, hei;
    world *wrd, *wrdT;
    std::vector<int> _stay, _birth;
};
class cellular {
public:
    cellular( int w, int h ) : rl( 0 ) {
        wrd = new world( w, h );
    }
    ~cellular() {
        if( rl ) delete rl;
        delete wrd;
    }
    void start( int r ) {
        rl = new rule( wrd );
        gen = 1;
        std::vector<int> t;
        switch( r ) {
            case 1: // conway
                t.push_back( 2 ); t.push_back( 3 ); rl->setRuleS( t );
                t.clear(); t.push_back( 3 ); rl->setRuleB( t );
                break;
            case 2: // amoeba
                t.push_back( 1 ); t.push_back( 3 ); t.push_back( 5 ); t.push_back( 8 ); rl->setRuleS( t );
                t.clear(); t.push_back( 3 ); t.push_back( 5 ); t.push_back( 7 ); rl->setRuleB( t );
                break;
            case 3: // life34
                t.push_back( 3 ); t.push_back( 4 ); rl->setRuleS( t );
                rl->setRuleB( t );
                break;
            case 4: // maze
                t.push_back( 1 ); t.push_back( 2 ); t.push_back( 3 ); t.push_back( 4 ); t.push_back( 5 ); rl->setRuleS( t );
                t.clear(); t.push_back( 3 ); rl->setRuleB( t );
                break;
        }

        /* just for test - shoud read from a file */
        /* GLIDER */
        wrd->set( 6, 1, 1 ); wrd->set( 7, 2, 1 );
        wrd->set( 5, 3, 1 ); wrd->set( 6, 3, 1 );
        wrd->set( 7, 3, 1 );
        /* BLINKER */
        wrd->set( 1, 3, 1 ); wrd->set( 2, 3, 1 );
        wrd->set( 3, 3, 1 );
        /******************************************/
        generation();
    }
private:
    void display() {
        system( "cls" );
        int wid = wrd->wid(),
            hei = wrd->hei();
        std::cout << "+" << std::string( wid, '-' ) << "+\n";
        for( int y = 0; y < hei; y++ ) {
            std::cout << "|";
            for( int x = 0; x < wid; x++ ) {
                if( wrd->at( x, y ) ) std::cout << "#";
                else std::cout << ".";
            }
            std::cout << "|\n";
        }
        std::cout << "+" << std::string( wid, '-' ) << "+\n";
        std::cout << "Generation: " << gen << "\n\nPress [RETURN] for the next generation...";
        std::cin.get();
    }
    void generation() {
        do {
            display();
            rl->applyRules();
            rl->swapWrds();
            gen++;
        }
        while ( rl->hasLivingCells() );
    }
    rule* rl;
    world* wrd;
    int gen;
};

int main( int argc, char* argv[] ) {
    cellular c( 20, 12 );
    std::cout << "\n\t*** CELLULAR AUTOMATA ***" << "\n\n Which one you want to run?\n\n\n";
    std::cout << " [1]\tConway's Life\n [2]\tAmoeba\n [3]\tLife 34\n [4]\tMaze\n\n > ";
    int o;
    do {
        std::cin >> o;
    }
    while( o < 1 || o > 4 );
    std::cin.ignore();
    c.start( o );
    return system( "pause" );
}
