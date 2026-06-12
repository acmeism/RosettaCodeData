#include <cassert>
#include <cstdint>
#include <iostream>

class bcd64 {
public:
    constexpr explicit bcd64(uint64_t bits = 0) : bits_(bits) {}
    constexpr bcd64& operator+=(bcd64 other) {
        uint64_t t1 = bits_ + 0x0666666666666666;
        uint64_t t2 = t1 + other.bits_;
        uint64_t t3 = t1 ^ other.bits_;
        uint64_t t4 = ~(t2 ^ t3) & 0x1111111111111110;
        uint64_t t5 = (t4 >> 2) | (t4 >> 3);
        bits_ = t2 - t5;
        return *this;
    }
    constexpr bcd64 operator-() const {
        uint64_t t1 = static_cast<uint64_t>(-static_cast<int64_t>(bits_));
        uint64_t t2 = t1 + 0xFFFFFFFFFFFFFFFF;
        uint64_t t3 = t2 ^ 1;
        uint64_t t4 = ~(t2 ^ t3) & 0x1111111111111110;
        uint64_t t5 = (t4 >> 2) | (t4 >> 3);
        return bcd64(t1 - t5);
    }
    friend constexpr bool operator==(bcd64 a, bcd64 b);
    friend std::ostream& operator<<(std::ostream& os, bcd64 a);

private:
    uint64_t bits_;
};

constexpr bool operator==(bcd64 a, bcd64 b) { return a.bits_ == b.bits_; }

constexpr bool operator!=(bcd64 a, bcd64 b) { return !(a == b); }

constexpr bcd64 operator+(bcd64 a, bcd64 b) {
    bcd64 sum(a);
    sum += b;
    return sum;
}

constexpr bcd64 operator-(bcd64 a, bcd64 b) { return a + -b; }

std::ostream& operator<<(std::ostream& os, bcd64 a) {
    auto f = os.flags();
    os << std::showbase << std::hex << a.bits_;
    os.flags(f);
    return os;
}

int main() {
    constexpr bcd64 one(0x01);
    assert(bcd64(0x19) + one == bcd64(0x20));
    std::cout << bcd64(0x19) + one << '\n';
    assert(bcd64(0x30) - one == bcd64(0x29));
    std::cout << bcd64(0x30) - one << '\n';
    assert(bcd64(0x99) + one == bcd64(0x100));
    std::cout << bcd64(0x99) + one << '\n';
}
