#include <array>
#include <iostream>

void require(bool condition, const std::string &message) {
    if (condition) {
        return;
    }
    throw std::runtime_error(message);
}

template<typename T, size_t N>
std::ostream &operator<<(std::ostream &os, const std::array<T, N> &a) {
    auto it = a.cbegin();
    auto end = a.cend();

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

template <size_t RC, size_t CC>
class Matrix {
    std::array<std::array<double, CC>, RC> data;

public:
    Matrix() : data{} {
        // empty
    }

    Matrix(std::initializer_list<std::initializer_list<double>> values) {
        size_t rp = 0;
        for (auto row : values) {
            size_t cp = 0;
            for (auto col : row) {
                data[rp][cp] = col;
                cp++;
            }
            rp++;
        }
    }

    double get(size_t row, size_t col) const {
        return data[row][col];
    }

    void set(size_t row, size_t col, double value) {
        data[row][col] = value;
    }

    std::array<double, CC> get(size_t row) {
        return data[row];
    }

    void set(size_t row, const std::array<double, CC> &values) {
        std::copy(values.begin(), values.end(), data[row].begin());
    }

    template <size_t D>
    Matrix<RC, D> operator*(const Matrix<CC, D> &rhs) const {
        Matrix<RC, D> result;
        for (size_t i = 0; i < RC; i++) {
            for (size_t j = 0; j < D; j++) {
                for (size_t k = 0; k < CC; k++) {
                    double prod = get(i, k) * rhs.get(k, j);
                    result.set(i, j, result.get(i, j) + prod);
                }
            }
        }
        return result;
    }

    Matrix<CC, RC> transpose() const {
        Matrix<CC, RC> trans;
        for (size_t i = 0; i < RC; i++) {
            for (size_t j = 0; j < CC; j++) {
                trans.set(j, i, data[i][j]);
            }
        }
        return trans;
    }

    void toReducedRowEchelonForm() {
        size_t lead = 0;
        for (size_t r = 0; r < RC; r++) {
            if (CC <= lead) {
                return;
            }
            auto i = r;

            while (get(i, lead) == 0.0) {
                i++;
                if (RC == i) {
                    i = r;
                    lead++;
                    if (CC == lead) {
                        return;
                    }
                }
            }

            auto temp = get(i);
            set(i, get(r));
            set(r, temp);

            if (get(r, lead) != 0.0) {
                auto div = get(r, lead);
                for (size_t j = 0; j < CC; j++) {
                    set(r, j, get(r, j) / div);
                }
            }

            for (size_t k = 0; k < RC; k++) {
                if (k != r) {
                    auto mult = get(k, lead);
                    for (size_t j = 0; j < CC; j++) {
                        auto prod = get(r, j) * mult;
                        set(k, j, get(k, j) - prod);
                    }
                }
            }

            lead++;
        }
    }

    Matrix<RC, RC> inverse() {
        require(RC == CC, "Not a square matrix");

        Matrix<RC, 2 * RC> aug;
        for (size_t i = 0; i < RC; i++) {
            for (size_t j = 0; j < RC; j++) {
                aug.set(i, j, get(i, j));
            }
            // augment identify matrix to right
            aug.set(i, i + RC, 1.0);
        }

        aug.toReducedRowEchelonForm();

        // remove identity matrix to left
        Matrix<RC, RC> inv;
        for (size_t i = 0; i < RC; i++) {
            for (size_t j = RC; j < 2 * RC; j++) {
                inv.set(i, j - RC, aug.get(i, j));
            }
        }
        return inv;
    }

    template <size_t RC, size_t CC>
    friend std::ostream &operator<<(std::ostream &, const Matrix<RC, CC> &);
};

template <size_t RC, size_t CC>
std::ostream &operator<<(std::ostream &os, const Matrix<RC, CC> &m) {
    for (size_t i = 0; i < RC; i++) {
        os << '[';
        for (size_t j = 0; j < CC; j++) {
            if (j > 0) {
                os << ", ";
            }
            os << m.get(i, j);
        }
        os << "]\n";
    }

    return os;
}

template <size_t RC, size_t CC>
std::array<double, RC> multiple_regression(const std::array<double, CC> &y, const Matrix<RC, CC> &x) {
    Matrix<1, CC> tm;
    tm.set(0, y);

    auto cy = tm.transpose();
    auto cx = x.transpose();
    return ((x * cx).inverse() * x * cy).transpose().get(0);
}

void case1() {
    std::array<double, 5> y{ 1.0, 2.0, 3.0, 4.0, 5.0 };
    Matrix<1, 5> x{ {2.0, 1.0, 3.0, 4.0, 5.0} };
    auto v = multiple_regression(y, x);
    std::cout << v << '\n';
}

void case2() {
    std::array<double, 3> y{ 3.0, 4.0, 5.0 };
    Matrix<2, 3> x{
        {1.0, 2.0, 1.0},
        {1.0, 1.0, 2.0}
    };
    auto v = multiple_regression(y, x);
    std::cout << v << '\n';
}

void case3() {
    std::array<double, 15> y{ 52.21, 53.12, 54.48, 55.84, 57.20, 58.57, 59.93, 61.29, 63.11, 64.47, 66.28, 68.10, 69.92, 72.19, 74.46 };
    std::array<double, 15> a{ 1.47, 1.50, 1.52, 1.55, 1.57, 1.60, 1.63, 1.65, 1.68, 1.70, 1.73, 1.75, 1.78, 1.80, 1.83 };

    Matrix<3, 15> x;
    for (size_t i = 0; i < 15; i++) {
        x.set(0, i, 1.0);
    }
    x.set(1, a);
    for (size_t i = 0; i < 15; i++) {
        x.set(2, i, a[i] * a[i]);
    }

    auto v = multiple_regression(y, x);
    std::cout << v << '\n';
}

int main() {
    case1();
    case2();
    case3();

    return 0;
}
