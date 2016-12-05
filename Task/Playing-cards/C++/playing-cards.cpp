#include <deque>
#include <algorithm>
#include <ostream>
#include <iterator>

namespace cards
{
class card
{
public:
    enum pip_type { two, three, four, five, six, seven, eight, nine, ten,
                    jack, queen, king, ace, pip_count };
    enum suite_type { hearts, spades, diamonds, clubs, suite_count };
    enum { unique_count = pip_count * suite_count };

    card(suite_type s, pip_type p): value(s + suite_count * p) {}

    explicit card(unsigned char v = 0): value(v) {}

    pip_type pip() { return pip_type(value / suite_count); }

    suite_type suite() { return suite_type(value % suite_count); }

private:
    unsigned char value;
};

const char* const pip_names[] =
    { "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
      "jack", "queen", "king", "ace" };

std::ostream& operator<<(std::ostream& os, card::pip_type pip)
{
    return os << pip_names[pip];
}

const char* const suite_names[] =
    { "hearts", "spades", "diamonds", "clubs" };

std::ostream& operator<<(std::ostream& os, card::suite_type suite)
{
    return os << suite_names[suite];
}

std::ostream& operator<<(std::ostream& os, card c)
{
    return os << c.pip() << " of " << c.suite();
}

class deck
{
public:
    deck()
    {
        for (int i = 0; i < card::unique_count; ++i) {
            cards.push_back(card(i));
        }
    }

    void shuffle() { std::random_shuffle(cards.begin(), cards.end()); }

    card deal() { card c = cards.front(); cards.pop_front(); return c; }

    typedef std::deque<card>::const_iterator const_iterator;
    const_iterator begin() const { return cards.cbegin(); }
    const_iterator end() const { return cards.cend(); }
private:
    std::deque<card> cards;
};

inline std::ostream& operator<<(std::ostream& os, const deck& d)
{
    std::copy(d.begin(), d.end(), std::ostream_iterator<card>(os, "\n"));
    return os;
}
}
