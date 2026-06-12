#include <algorithm>
#include <iostream>
#include <random>
#include <vector>

double uniform01() {
    static std::default_random_engine generator;
    static std::uniform_real_distribution<double> distribution(0.0, 1.0);
    return distribution(generator);
}

int bitCount(int i) {
    i -= ((i >> 1) & 0x55555555);
    i = (i & 0x33333333) + ((i >> 2) & 0x33333333);
    i = (i + (i >> 4)) & 0x0F0F0F0F;
    i += (i >> 8);
    i += (i >> 16);
    return i & 0x0000003F;
}

double reorderingSign(int i, int j) {
    int k = i >> 1;
    int sum = 0;
    while (k != 0) {
        sum += bitCount(k & j);
        k = k >> 1;
    }
    return ((sum & 1) == 0) ? 1.0 : -1.0;
}

struct MyVector {
public:
    MyVector(const std::vector<double> &da) : dims(da) {
        // empty
    }

    double &operator[](size_t i) {
        return dims[i];
    }

    const double &operator[](size_t i) const {
        return dims[i];
    }

    MyVector operator+(const MyVector &rhs) const {
        std::vector<double> temp(dims);
        for (size_t i = 0; i < rhs.dims.size(); ++i) {
            temp[i] += rhs[i];
        }
        return MyVector(temp);
    }

    MyVector operator*(const MyVector &rhs) const {
        std::vector<double> temp(dims.size(), 0.0);
        for (size_t i = 0; i < dims.size(); i++) {
            if (dims[i] != 0.0) {
                for (size_t j = 0; j < dims.size(); j++) {
                    if (rhs[j] != 0.0) {
                        auto s = reorderingSign(i, j) * dims[i] * rhs[j];
                        auto k = i ^ j;
                        temp[k] += s;
                    }
                }
            }
        }
        return MyVector(temp);
    }

    MyVector operator*(double scale) const {
        std::vector<double> temp(dims);
        std::for_each(temp.begin(), temp.end(), [scale](double a) { return a * scale; });
        return MyVector(temp);
    }

    MyVector operator-() const {
        return *this * -1.0;
    }

    MyVector dot(const MyVector &rhs) const {
        return (*this * rhs + rhs * *this) * 0.5;
    }

    friend std::ostream &operator<<(std::ostream &, const MyVector &);

private:
    std::vector<double> dims;
};

std::ostream &operator<<(std::ostream &os, const MyVector &v) {
    auto it = v.dims.cbegin();
    auto end = v.dims.cend();

    os << '[';
    if (it != end) {
        os << *it;
        it = std::next(it);
    }
    while (it != end) {
        os << ", " << *it;
        it = std::next(it);
    }
    return os << ']';
}

MyVector e(int n) {
    if (n > 4) {
        throw new std::runtime_error("n must be less than 5");
    }

    auto result = MyVector(std::vector<double>(32, 0.0));
    result[1 << n] = 1.0;
    return result;
}

MyVector randomVector() {
    auto result = MyVector(std::vector<double>(32, 0.0));
    for (int i = 0; i < 5; i++) {
        result = result + MyVector(std::vector<double>(1, uniform01())) * e(i);
    }
    return result;
}

MyVector randomMultiVector() {
    auto result = MyVector(std::vector<double>(32, 0.0));
    for (int i = 0; i < 32; i++) {
        result[i] = uniform01();
    }
    return result;
}

int main() {
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            if (i < j) {
                if (e(i).dot(e(j))[0] != 0.0) {
                    std::cout << "Unexpected non-null scalar product.";
                    return 1;
                } else if (i == j) {
                    if (e(i).dot(e(j))[0] == 0.0) {
                        std::cout << "Unexpected null scalar product.";
                    }
                }
            }
        }
    }

    auto a = randomMultiVector();
    auto b = randomMultiVector();
    auto c = randomMultiVector();
    auto x = randomVector();

    // (ab)c == a(bc)
    std::cout << ((a * b) * c) << '\n';
    std::cout << (a * (b * c)) << "\n\n";

    // a(b+c) == ab + ac
    std::cout << (a * (b + c)) << '\n';
    std::cout << (a * b + a * c) << "\n\n";

    // (a+b)c == ac + bc
    std::cout << ((a + b) * c) << '\n';
    std::cout << (a * c + b * c) << "\n\n";

    // x^2 is real
    std::cout << (x * x) << '\n';

    return 0;
}
