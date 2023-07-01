#include <iostream>

class factorion_t {
public:
    factorion_t() {
        f[0] = 1u;
        for (uint n = 1u; n < 12u; n++)
            f[n] = f[n - 1] * n;
    }

    bool operator()(uint i, uint b) const {
        uint sum = 0;
        for (uint j = i; j > 0u; j /= b)
            sum += f[j % b];
        return sum == i;
    }

private:
    ulong f[12];  //< cache factorials from 0 to 11
};

int main() {
    factorion_t factorion;
    for (uint b = 9u; b <= 12u; ++b) {
        std::cout << "factorions for base " << b << ':';
        for (uint i = 1u; i < 1500000u; ++i)
            if (factorion(i, b))
                std::cout << ' ' << i;
        std::cout << std::endl;
    }
    return 0;
}
