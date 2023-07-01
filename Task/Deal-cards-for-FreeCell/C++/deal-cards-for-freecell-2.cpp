#include <string>       // std::string
#include <iostream>     // std::cout
#include <sstream>      // std::stringstream
#include <vector>       // std::vector

using namespace std;

//------------------------------------------------------------------------------

class Random {
public:
        void init(uint32_t seed) { _seed = seed; }
        int roll() { return (_seed = (_seed * MULT + INCR) & MASK) >> 16; }
private:
        int _seed;
        enum { MULT = 214013, INCR = 2531011, MASK = (1U << 31) - 1 };
};

//------------------------------------------------------------------------------

class Card {
public:
        Card(int value) : _value(value) { }
        int suit() const { return _value % 4; }
        int rank() const { return _value / 4; }
        string str() const {
                stringstream s; s << _ranks[rank()] << _suits[suit()]; return s.str();
        }
private:
        int _value;
        const char* _suits = "CDHS";
        const char* _ranks = "A23456789TJQK";
};

//------------------------------------------------------------------------------

class Deck {
public:
        Deck(int seed) {
                _random.init(seed);
                for (int i = 0; i < 52; i++)
                        _cards.push_back(Card(51 - i));
                for (int i = 0; i < 51; i++) {
                        int j = 51 - _random.roll() % (52 - i);
                        swap(_cards[i], _cards[j]);
                }
        }
        string str() const {
                stringstream s;
                for (int i = 0; i < _cards.size(); i++)
                        s << _cards[i].str() << (i % 8 == 7 || i == 51 ? "\n" : " ");
                return s.str();
        }
private:
        vector<Card>    _cards;
        Random          _random;
};

//------------------------------------------------------------------------------

int main(int argc, const char * argv[])
{
        {
                Deck deck(1);
                cout << "Deck 1" << endl << deck.str() << endl;
        }
        {
                Deck deck(617);
                cout << "Deck 617" << endl << deck.str() << endl;
        }
        return 0;
}
