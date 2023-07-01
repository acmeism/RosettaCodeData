#include <array>
#include <cstdint>
#include <iostream>

class XorShiftStar {
private:
    const uint64_t MAGIC = 0x2545F4914F6CDD1D;
    uint64_t state;
public:
    void seed(uint64_t num) {
        state = num;
    }

    uint32_t next_int() {
        uint64_t x;
        uint32_t answer;

        x = state;
        x = x ^ (x >> 12);
        x = x ^ (x << 25);
        x = x ^ (x >> 27);
        state = x;
        answer = ((x * MAGIC) >> 32);

        return answer;
    }

    float next_float() {
        return (float)next_int() / (1LL << 32);
    }
};

int main() {
    auto rng = new XorShiftStar();
    rng->seed(1234567);
    std::cout << rng->next_int() << '\n';
    std::cout << rng->next_int() << '\n';
    std::cout << rng->next_int() << '\n';
    std::cout << rng->next_int() << '\n';
    std::cout << rng->next_int() << '\n';
    std::cout << '\n';

    std::array<int, 5> counts = { 0, 0, 0, 0, 0 };
    rng->seed(987654321);
    for (int i = 0; i < 100000; i++) {
        int j = (int)floor(rng->next_float() * 5.0);
        counts[j]++;
    }
    for (size_t i = 0; i < counts.size(); i++) {
        std::cout << i << ": " << counts[i] << '\n';
    }

    return 0;
}
