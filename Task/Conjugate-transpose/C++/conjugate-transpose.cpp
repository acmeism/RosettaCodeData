#include <cassert>
#include <cmath>
#include <complex>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <vector>

template <typename scalar_type> class complex_matrix {
public:
    using element_type = std::complex<scalar_type>;

    complex_matrix(size_t rows, size_t columns)
        : rows_(rows), columns_(columns), elements_(rows * columns) {}

    complex_matrix(size_t rows, size_t columns, element_type value)
        : rows_(rows), columns_(columns), elements_(rows * columns, value) {}

    complex_matrix(size_t rows, size_t columns,
        const std::initializer_list<std::initializer_list<element_type>>& values)
        : rows_(rows), columns_(columns), elements_(rows * columns) {
        assert(values.size() <= rows_);
        size_t i = 0;
        for (const auto& row : values) {
            assert(row.size() <= columns_);
            std::copy(begin(row), end(row), &elements_[i]);
            i += columns_;
        }
    }

    size_t rows() const { return rows_; }
    size_t columns() const { return columns_; }

    const element_type& operator()(size_t row, size_t column) const {
        assert(row < rows_);
        assert(column < columns_);
        return elements_[row * columns_ + column];
    }
    element_type& operator()(size_t row, size_t column) {
        assert(row < rows_);
        assert(column < columns_);
        return elements_[row * columns_ + column];
    }

    friend bool operator==(const complex_matrix& a, const complex_matrix& b) {
        return a.rows_ == b.rows_ && a.columns_ == b.columns_ &&
               a.elements_ == b.elements_;
    }

private:
    size_t rows_;
    size_t columns_;
    std::vector<element_type> elements_;
};

template <typename scalar_type>
complex_matrix<scalar_type> product(const complex_matrix<scalar_type>& a,
                                    const complex_matrix<scalar_type>& b) {
    assert(a.columns() == b.rows());
    size_t arows = a.rows();
    size_t bcolumns = b.columns();
    size_t n = a.columns();
    complex_matrix<scalar_type> c(arows, bcolumns);
    for (size_t i = 0; i < arows; ++i) {
        for (size_t j = 0; j < n; ++j) {
            for (size_t k = 0; k < bcolumns; ++k)
                c(i, k) += a(i, j) * b(j, k);
        }
    }
    return c;
}

template <typename scalar_type>
complex_matrix<scalar_type>
conjugate_transpose(const complex_matrix<scalar_type>& a) {
    size_t rows = a.rows(), columns = a.columns();
    complex_matrix<scalar_type> b(columns, rows);
    for (size_t i = 0; i < columns; i++) {
        for (size_t j = 0; j < rows; j++) {
            b(i, j) = std::conj(a(j, i));
        }
    }
    return b;
}

template <typename scalar_type>
std::string to_string(const std::complex<scalar_type>& c) {
    std::ostringstream out;
    const int precision = 6;
    out << std::fixed << std::setprecision(precision);
    out << std::setw(precision + 3) << c.real();
    if (c.imag() > 0)
        out << " + " << std::setw(precision + 2) << c.imag() << 'i';
    else if (c.imag() == 0)
        out << " + " << std::setw(precision + 2) << 0.0 << 'i';
    else
        out << " - " << std::setw(precision + 2) << -c.imag() << 'i';
    return out.str();
}

template <typename scalar_type>
void print(std::ostream& out, const complex_matrix<scalar_type>& a) {
    size_t rows = a.rows(), columns = a.columns();
    for (size_t row = 0; row < rows; ++row) {
        for (size_t column = 0; column < columns; ++column) {
            if (column > 0)
                out << ' ';
            out << to_string(a(row, column));
        }
        out << '\n';
    }
}

template <typename scalar_type>
bool is_hermitian_matrix(const complex_matrix<scalar_type>& matrix) {
    if (matrix.rows() != matrix.columns())
        return false;
    return matrix == conjugate_transpose(matrix);
}

template <typename scalar_type>
bool is_normal_matrix(const complex_matrix<scalar_type>& matrix) {
    if (matrix.rows() != matrix.columns())
        return false;
    auto c = conjugate_transpose(matrix);
    return product(c, matrix) == product(matrix, c);
}

bool is_equal(const std::complex<double>& a, double b) {
    constexpr double e = 1e-15;
    return std::abs(a.imag()) < e && std::abs(a.real() - b) < e;
}

template <typename scalar_type>
bool is_identity_matrix(const complex_matrix<scalar_type>& matrix) {
    if (matrix.rows() != matrix.columns())
        return false;
    size_t rows = matrix.rows();
    for (size_t i = 0; i < rows; ++i) {
        for (size_t j = 0; j < rows; ++j) {
            if (!is_equal(matrix(i, j), scalar_type(i == j ? 1 : 0)))
                return false;
        }
    }
    return true;
}

template <typename scalar_type>
bool is_unitary_matrix(const complex_matrix<scalar_type>& matrix) {
    if (matrix.rows() != matrix.columns())
        return false;
    auto c = conjugate_transpose(matrix);
    auto p = product(c, matrix);
    return is_identity_matrix(p) && p == product(matrix, c);
}

template <typename scalar_type>
void test(const complex_matrix<scalar_type>& matrix) {
    std::cout << "Matrix:\n";
    print(std::cout, matrix);
    std::cout << "Conjugate transpose:\n";
    print(std::cout, conjugate_transpose(matrix));
    std::cout << std::boolalpha;
    std::cout << "Hermitian: " << is_hermitian_matrix(matrix) << '\n';
    std::cout << "Normal: " << is_normal_matrix(matrix) << '\n';
    std::cout << "Unitary: " << is_unitary_matrix(matrix) << '\n';
}

int main() {
    using matrix = complex_matrix<double>;

    matrix matrix1(3, 3, {{{2, 0}, {2, 1}, {4, 0}},
                          {{2, -1}, {3, 0}, {0, 1}},
                          {{4, 0}, {0, -1}, {1, 0}}});

    double n = std::sqrt(0.5);
    matrix matrix2(3, 3, {{{n, 0}, {n, 0}, {0, 0}},
                          {{0, -n}, {0, n}, {0, 0}},
                          {{0, 0}, {0, 0}, {0, 1}}});

    matrix matrix3(3, 3, {{{2, 2}, {3, 1}, {-3, 5}},
                          {{2, -1}, {4, 1}, {0, 0}},
                          {{7, -5}, {1, -4}, {1, 0}}});

    test(matrix1);
    std::cout << '\n';
    test(matrix2);
    std::cout << '\n';
    test(matrix3);
    return 0;
}
