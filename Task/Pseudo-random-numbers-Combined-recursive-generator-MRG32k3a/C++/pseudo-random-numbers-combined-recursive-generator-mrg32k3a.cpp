#include <array>
#include <iostream>

int64_t mod(int64_t x, int64_t y) {
    int64_t m = x % y;
    if (m < 0) {
        if (y < 0) {
            return m - y;
        } else {
            return m + y;
        }
    }
    return m;
}

class RNG {
private:
    // First generator
    const std::array<int64_t, 3> a1{ 0, 1403580, -810728 };
    const int64_t m1 = (1LL << 32) - 209;
    std::array<int64_t, 3> x1;
    // Second generator
    const std::array<int64_t, 3> a2{ 527612, 0, -1370589 };
    const int64_t m2 = (1LL << 32) - 22853;
    std::array<int64_t, 3> x2;
    // other
    const int64_t d = (1LL << 32) - 209 + 1; // m1 + 1

public:
    void seed(int64_t state) {
        x1 = { state, 0, 0 };
        x2 = { state, 0, 0 };
    }

    int64_t next_int() {
        int64_t x1i = mod((a1[0] * x1[0] + a1[1] * x1[1] + a1[2] * x1[2]), m1);
        int64_t x2i = mod((a2[0] * x2[0] + a2[1] * x2[1] + a2[2] * x2[2]), m2);
        int64_t z = mod(x1i - x2i, m1);

        // keep last three values of the first generator
        x1 = { x1i, x1[0], x1[1] };
        // keep last three values of the second generator
        x2 = { x2i, x2[0], x2[1] };

        return z + 1;
    }

    double next_float() {
        return static_cast<double>(next_int()) / d;
    }
};

int main() {
    RNG rng;

    rng.seed(1234567);
    std::cout << rng.next_int() << '\n';
    std::cout << rng.next_int() << '\n';
    std::cout << rng.next_int() << '\n';
    std::cout << rng.next_int() << '\n';
    std::cout << rng.next_int() << '\n';
    std::cout << '\n';

    std::array<int, 5> counts{ 0, 0, 0, 0, 0 };
    rng.seed(987654321);
    for (size_t i = 0; i < 100000; i++) 		{
        auto value = floor(rng.next_float() * 5.0);
        counts[value]++;
    }
    for (size_t i = 0; i < counts.size(); i++) 		{
        std::cout << i << ": " << counts[i] << '\n';
    }

    return 0;
}
