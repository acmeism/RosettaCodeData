#include <exception>
#include <iostream>

using ulong = unsigned long;

class MiddleSquare {
private:
    ulong state;
    ulong div, mod;
public:
    MiddleSquare() = delete;
    MiddleSquare(ulong start, ulong length) {
        if (length % 2) throw std::invalid_argument("length must be even");
        div = mod = 1;
        for (ulong i=0; i<length/2; i++) div *= 10;
        for (ulong i=0; i<length; i++) mod *= 10;
        state = start % mod;
    }

    ulong next() {
        return state = state * state / div % mod;
    }
};

int main() {
    MiddleSquare msq(675248, 6);
    for (int i=0; i<5; i++)
        std::cout << msq.next() << std::endl;
    return 0;
}
