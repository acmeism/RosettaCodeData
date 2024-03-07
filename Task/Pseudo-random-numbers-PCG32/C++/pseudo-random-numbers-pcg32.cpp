#include <array>
#include <iostream>
#include <math.h>

class PCG32 {
private:
    const uint64_t N = 6364136223846793005;
    uint64_t state = 0x853c49e6748fea9b;
    uint64_t inc = 0xda3e39cb94b95bdb;
public:
    uint32_t nextInt() {
        uint64_t old = state;
        state = old * N + inc;
        uint32_t shifted = (uint32_t)(((old >> 18) ^ old) >> 27);
        uint32_t rot = old >> 59;
        return (shifted >> rot) | (shifted << ((~rot + 1) & 31));
    }

    double nextFloat() {
        return ((double)nextInt()) / (1LL << 32);
    }

    void seed(uint64_t seed_state, uint64_t seed_sequence) {
        state = 0;
        inc = (seed_sequence << 1) | 1;
        nextInt();
        state = state + seed_state;
        nextInt();
    }
};

int main() {
    auto r = new PCG32();

    r->seed(42, 54);
    std::cout << r->nextInt() << '\n';
    std::cout << r->nextInt() << '\n';
    std::cout << r->nextInt() << '\n';
    std::cout << r->nextInt() << '\n';
    std::cout << r->nextInt() << '\n';
    std::cout << '\n';

    std::array<int, 5> counts{ 0, 0, 0, 0, 0 };
    r->seed(987654321, 1);
    for (size_t i = 0; i < 100000; i++) {
        int j = (int)floor(r->nextFloat() * 5.0);
        counts[j]++;
    }

    std::cout << "The counts for 100,000 repetitions are:\n";
    for (size_t i = 0; i < counts.size(); i++) {
        std::cout << "  " << i << " : " << counts[i] << '\n';
    }

    return 0;
}
