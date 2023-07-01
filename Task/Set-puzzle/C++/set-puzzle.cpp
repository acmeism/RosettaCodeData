#include <time.h>
#include <algorithm>
#include <iostream>
#include <iomanip>
#include <vector>
#include <string>

enum color {
    red, green, purple
};
enum symbol {
    oval, squiggle, diamond
};
enum number {
    one, two, three
};
enum shading {
    solid, open, striped
};
class card {
public:
    card( color c, symbol s, number n, shading h ) {
        clr = c; smb = s; nbr = n; shd = h;
    }
    color getColor() {
        return clr;
    }
    symbol getSymbol() {
        return smb;
    }
    number getNumber() {
        return nbr;
    }
    shading getShading() {
        return shd;
    }
    std::string toString() {
        std::string str = "[";
        str += clr == red ? "red " : clr == green ? "green " : "purple ";
        str += nbr == one ? "one " : nbr == two ? "two " : "three ";
        str += smb == oval ? "oval " : smb == squiggle ? "squiggle " : "diamond ";
        str += shd == solid ? "solid" : shd == open ? "open" : "striped";
        return str + "]";
    }
private:
    color    clr;
    symbol   smb;
    number   nbr;
    shading  shd;
};
typedef struct {
    std::vector<size_t> index;
} set;
class setPuzzle {
public:
    setPuzzle() {
        for( size_t c = red; c <= purple; c++ ) {
            for( size_t s = oval; s <= diamond; s++ ) {
                for( size_t n = one; n <= three; n++ ) {
                    for( size_t h = solid; h <= striped; h++ ) {
                        card crd( static_cast<color>  ( c ),
                                  static_cast<symbol> ( s ),
                                  static_cast<number> ( n ),
                                  static_cast<shading>( h ) );
                        _cards.push_back( crd );
                    }
                }
            }
        }
    }
    void create( size_t countCards, size_t countSets, std::vector<card>& cards, std::vector<set>& sets ) {
        while( true ) {
            sets.clear();
            cards.clear();
            std::random_shuffle( _cards.begin(), _cards.end() );
            for( size_t f = 0; f < countCards; f++ ) {
                cards.push_back( _cards.at( f ) );
            }
            for( size_t c1 = 0; c1 < cards.size() - 2; c1++ ) {
                for( size_t c2 = c1 + 1; c2 < cards.size() - 1; c2++ ) {
                    for( size_t c3 = c2 + 1; c3 < cards.size(); c3++ ) {
                        if( testSet( &cards.at( c1 ), &cards.at( c2 ), &cards.at( c3 ) ) ) {
                            set s;
                            s.index.push_back( c1 ); s.index.push_back( c2 ); s.index.push_back( c3 );
                            sets.push_back( s );
                        }
                    }
                }
            }
            if( sets.size() == countSets ) return;
        }
    }
private:
    bool testSet( card* c1, card* c2, card* c3 ) {
        int
        c = ( c1->getColor()   + c2->getColor()   + c3->getColor()   ) % 3,
        s = ( c1->getSymbol()  + c2->getSymbol()  + c3->getSymbol()  ) % 3,
        n = ( c1->getNumber()  + c2->getNumber()  + c3->getNumber()  ) % 3,
        h = ( c1->getShading() + c2->getShading() + c3->getShading() ) % 3;
        return !( c + s + n + h );
    }
    std::vector<card> _cards;
};
void displayCardsSets( std::vector<card>& cards, std::vector<set>& sets ) {
    size_t cnt = 1;
    std::cout << " ** DEALT " << cards.size() << " CARDS: **\n";
    for( std::vector<card>::iterator i = cards.begin(); i != cards.end(); i++ ) {
        std::cout << std::setw( 2 ) << cnt++ << ": " << ( *i ).toString() << "\n";
    }
    std::cout << "\n ** CONTAINING " << sets.size() << " SETS: **\n";
    for( std::vector<set>::iterator i = sets.begin(); i != sets.end(); i++ ) {
        for( size_t j = 0; j < ( *i ).index.size(); j++ ) {
            std::cout << " " << std::setiosflags( std::ios::left ) << std::setw( 34 )
                      << cards.at( ( *i ).index.at( j ) ).toString() << " : "
                      << std::resetiosflags( std::ios::left ) << std::setw( 2 ) << ( *i ).index.at( j ) + 1 << "\n";
        }
        std::cout << "\n";
    }
    std::cout << "\n\n";
}
int main( int argc, char* argv[] ) {
    srand( static_cast<unsigned>( time( NULL ) ) );
    setPuzzle p;
    std::vector<card> v9, v12;
    std::vector<set>  s4, s6;
    p.create(  9, 4,  v9, s4 );
    p.create( 12, 6, v12, s6 );
    displayCardsSets(  v9, s4 );
    displayCardsSets( v12, s6 );
    return 0;
}
