#include <boost/multiprecision/cpp_dec_float.hpp>
#include <iostream>

const char* names[] = { "Platinum", "Golden", "Silver", "Bronze", "Copper", "Nickel", "Aluminium", "Iron", "Tin", "Lead" };

template<const uint N>
void lucas(ulong b) {
    std::cout << "Lucas sequence for " << names[b] << " ratio, where b = " << b << ":\nFirst " << N << " elements: ";
    auto x0 = 1L, x1 = 1L;
    std::cout << x0 << ", " << x1;
    for (auto i = 1u; i <= N - 1 - 1; i++) {
        auto x2 = b * x1 + x0;
        std::cout << ", " << x2;
        x0 = x1;
        x1 = x2;
    }
    std::cout << std::endl;
}

template<const ushort P>
void metallic(ulong b) {
    using namespace boost::multiprecision;
    using bfloat = number<cpp_dec_float<P+1>>;
    bfloat x0(1), x1(1);
    auto prev = bfloat(1).str(P+1);
    for (auto i = 0u;;) {
        i++;
        bfloat x2(b * x1 + x0);
        auto thiz = bfloat(x2 / x1).str(P+1);
        if (prev == thiz) {
            std::cout << "Value after " << i << " iteration" << (i == 1 ? ": " : "s: ") << thiz << std::endl << std::endl;
            break;
        }
        prev = thiz;
        x0 = x1;
        x1 = x2;
    }
}

int main() {
    for (auto b = 0L; b < 10L; b++) {
        lucas<15>(b);
        metallic<32>(b);
    }
    std::cout << "Golden ratio, where b = 1:" << std::endl;
    metallic<256>(1);

    return 0;
}
