#pragma once

#include <cmath>
#include <sstream>
#include <iomanip>

inline bool is_prime(unsigned a)  {
   if (a == 2) return true;
   if (a <= 1 || a % 2 == 0) return false;
   const unsigned max(std::sqrt(a));
   for (unsigned n = 3; n <= max; n += 2) if (a % n == 0)  return false;
   return true;
}

enum direction { RIGHT, UP, LEFT, DOWN };
const char* N = " ---";

template<const unsigned SIZE>
class Ulam
{
public:
    Ulam(unsigned start = 1, const char c = '\0') {
        direction dir = RIGHT;
        unsigned y = SIZE / 2;
        unsigned x = SIZE % 2 == 0 ?  y - 1 :  y; // shift left for even n's
        for (unsigned j = start; j <= SIZE * SIZE - 1 + start; j++) {
            if (is_prime(j)) {
                std::ostringstream os("");
                if (c == '\0') os << std::setw(4) << j;
                else           os << "  " << c << ' ';
                s[y][x] = os.str();
            }
            else s[y][x] = N;

            switch (dir) {
            case RIGHT : if (x <= SIZE - 1 && s[y - 1][x].empty() && j > start) { dir = UP; }; break;
            case UP : if (s[y][x - 1].empty()) { dir = LEFT; }; break;
            case LEFT : if (x == 0 || s[y + 1][x].empty()) { dir = DOWN; }; break;
            case DOWN : if (s[y][x + 1].empty()) { dir = RIGHT; }; break;
            }

            switch (dir) {
            case RIGHT : x += 1; break;
            case UP : y -= 1; break;
            case LEFT : x -= 1; break;
            case DOWN : y += 1; break;
            }
        }
    }

    template<const unsigned S> friend std::ostream& operator <<(std::ostream&, const Ulam<S>&);

private:
    std::string s[SIZE][SIZE];
};

template<const unsigned SIZE>
std::ostream& operator <<(std::ostream& os, const Ulam<SIZE>& u) {
    for (unsigned i = 0; i < SIZE; i++) {
        os << '[';
        for (unsigned j = 0; j < SIZE; j++) os << u.s[i][j];
        os << ']' << std::endl;
    }
    return os;
}
