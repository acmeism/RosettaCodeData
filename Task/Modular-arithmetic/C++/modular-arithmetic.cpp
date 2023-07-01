#include <iostream>
#include <ostream>

template<typename T>
T f(const T& x) {
    return (T) pow(x, 100) + x + 1;
}

class ModularInteger {
private:
    int value;
    int modulus;

    void validateOp(const ModularInteger& rhs) const {
        if (modulus != rhs.modulus) {
            throw std::runtime_error("Left-hand modulus does not match right-hand modulus.");
        }
    }

public:
    ModularInteger(int v, int m) {
        modulus = m;
        value = v % m;
    }

    int getValue() const {
        return value;
    }

    int getModulus() const {
        return modulus;
    }

    ModularInteger operator+(const ModularInteger& rhs) const {
        validateOp(rhs);
        return ModularInteger(value + rhs.value, modulus);
    }

    ModularInteger operator+(int rhs) const {
        return ModularInteger(value + rhs, modulus);
    }

    ModularInteger operator*(const ModularInteger& rhs) const {
        validateOp(rhs);
        return ModularInteger(value * rhs.value, modulus);
    }

    friend std::ostream& operator<<(std::ostream&, const ModularInteger&);
};

std::ostream& operator<<(std::ostream& os, const ModularInteger& self) {
    return os << "ModularInteger(" << self.value << ", " << self.modulus << ")";
}

ModularInteger pow(const ModularInteger& lhs, int pow) {
    if (pow < 0) {
        throw std::runtime_error("Power must not be negative.");
    }

    ModularInteger base(1, lhs.getModulus());
    while (pow-- > 0) {
        base = base * lhs;
    }
    return base;
}

int main() {
    using namespace std;

    ModularInteger input(10, 13);
    auto output = f(input);
    cout << "f(" << input << ") = " << output << endl;

    return 0;
}
