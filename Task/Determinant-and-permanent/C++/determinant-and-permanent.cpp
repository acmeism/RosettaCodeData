#include <iostream>
#include <vector>

template <typename T>
std::ostream &operator<<(std::ostream &os, const std::vector<T> &v) {
    auto it = v.cbegin();
    auto end = v.cend();

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

using Matrix = std::vector<std::vector<double>>;

Matrix squareMatrix(size_t n) {
    Matrix m;
    for (size_t i = 0; i < n; i++) {
        std::vector<double> inner;
        for (size_t j = 0; j < n; j++) {
            inner.push_back(nan(""));
        }
        m.push_back(inner);
    }
    return m;
}

Matrix minor(const Matrix &a, int x, int y) {
    auto length = a.size() - 1;
    auto result = squareMatrix(length);
    for (int i = 0; i < length; i++) {
        for (int j = 0; j < length; j++) {
            if (i < x && j < y) {
                result[i][j] = a[i][j];
            } else if (i >= x && j < y) {
                result[i][j] = a[i + 1][j];
            } else if (i < x && j >= y) {
                result[i][j] = a[i][j + 1];
            } else {
                result[i][j] = a[i + 1][j + 1];
            }
        }
    }
    return result;
}

double det(const Matrix &a) {
    if (a.size() == 1) {
        return a[0][0];
    }

    int sign = 1;
    double sum = 0;
    for (size_t i = 0; i < a.size(); i++) {
        sum += sign * a[0][i] * det(minor(a, 0, i));
        sign *= -1;
    }
    return sum;
}

double perm(const Matrix &a) {
    if (a.size() == 1) {
        return a[0][0];
    }

    double sum = 0;
    for (size_t i = 0; i < a.size(); i++) {
        sum += a[0][i] * perm(minor(a, 0, i));
    }
    return sum;
}

void test(const Matrix &m) {
    auto p = perm(m);
    auto d = det(m);

    std::cout << m << '\n';
    std::cout << "Permanent: " << p << ", determinant: " << d << "\n\n";
}

int main() {
    test({ {1, 2}, {3, 4} });
    test({ {1, 2, 3, 4}, {4, 5, 6, 7}, {7, 8, 9, 10}, {10, 11, 12, 13} });
    test({ {0, 1, 2, 3, 4}, {5, 6, 7, 8, 9}, {10, 11, 12, 13, 14}, {15, 16, 17, 18, 19}, {20, 21, 22, 23, 24} });

    return 0;
}
