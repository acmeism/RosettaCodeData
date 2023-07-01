#include <cassert>
#include <cmath>
#include <iostream>
#include <valarray>

template <typename scalar_type> class matrix {
public:
    matrix(size_t rows, size_t columns) : rows_(rows), columns_(columns) {
        elements_.resize(rows * columns);
    }
    matrix(size_t rows, size_t columns, scalar_type value)
        : rows_(rows), columns_(columns), elements_(value, rows * columns) {}

    size_t rows() const { return rows_; }
    size_t columns() const { return columns_; }

    const scalar_type& at(size_t row, size_t column) const {
        assert(row < rows_);
        assert(column < columns_);
        return elements_[index(row, column)];
    }
    scalar_type& at(size_t row, size_t column) {
        assert(row < rows_);
        assert(column < columns_);
        return elements_[index(row, column)];
    }

    matrix& operator+=(scalar_type e) {
        elements_ += e;
        return *this;
    }
    matrix& operator-=(scalar_type e) {
        elements_ -= e;
        return *this;
    }
    matrix& operator*=(scalar_type e) {
        elements_ *= e;
        return *this;
    }
    matrix& operator/=(scalar_type e) {
        elements_ /= e;
        return *this;
    }

    matrix& operator+=(const matrix& other) {
        assert(rows_ == other.rows_);
        assert(columns_ == other.columns_);
        elements_ += other.elements_;
        return *this;
    }
    matrix& operator-=(const matrix& other) {
        assert(rows_ == other.rows_);
        assert(columns_ == other.columns_);
        elements_ -= other.elements_;
        return *this;
    }
    matrix& operator*=(const matrix& other) {
        assert(rows_ == other.rows_);
        assert(columns_ == other.columns_);
        elements_ *= other.elements_;
        return *this;
    }
    matrix& operator/=(const matrix& other) {
        assert(rows_ == other.rows_);
        assert(columns_ == other.columns_);
        elements_ /= other.elements_;
        return *this;
    }

    matrix& negate() {
        for (scalar_type& element : elements_)
            element = -element;
        return *this;
    }
    matrix& invert() {
        for (scalar_type& element : elements_)
            element = 1 / element;
        return *this;
    }

    friend matrix pow(const matrix& a, scalar_type b) {
        return matrix(a.rows_, a.columns_, std::pow(a.elements_, b));
    }
    friend matrix pow(const matrix& a, const matrix& b) {
        assert(a.rows_ == b.rows_);
        assert(a.columns_ == b.columns_);
        return matrix(a.rows_, a.columns_, std::pow(a.elements_, b.elements_));
    }
private:
    matrix(size_t rows, size_t columns, std::valarray<scalar_type>&& values)
        : rows_(rows), columns_(columns), elements_(std::move(values)) {}

    size_t index(size_t row, size_t column) const {
        return row * columns_ + column;
    }
    size_t rows_;
    size_t columns_;
    std::valarray<scalar_type> elements_;
};

template <typename scalar_type>
matrix<scalar_type> operator+(const matrix<scalar_type>& a, scalar_type b) {
    matrix<scalar_type> c(a);
    c += b;
    return c;
}

template <typename scalar_type>
matrix<scalar_type> operator-(const matrix<scalar_type>& a, scalar_type b) {
    matrix<scalar_type> c(a);
    c -= b;
    return c;
}

template <typename scalar_type>
matrix<scalar_type> operator*(const matrix<scalar_type>& a, scalar_type b) {
    matrix<scalar_type> c(a);
    c *= b;
    return c;
}

template <typename scalar_type>
matrix<scalar_type> operator/(const matrix<scalar_type>& a, scalar_type b) {
    matrix<scalar_type> c(a);
    c /= b;
    return c;
}

template <typename scalar_type>
matrix<scalar_type> operator+(scalar_type a, const matrix<scalar_type>& b) {
    matrix<scalar_type> c(b);
    c += a;
    return c;
}

template <typename scalar_type>
matrix<scalar_type> operator-(scalar_type a, const matrix<scalar_type>& b) {
    matrix<scalar_type> c(b);
    c.negate() += a;
    return c;
}

template <typename scalar_type>
matrix<scalar_type> operator*(scalar_type a, const matrix<scalar_type>& b) {
    matrix<scalar_type> c(b);
    c *= a;
    return c;
}

template <typename scalar_type>
matrix<scalar_type> operator/(scalar_type a, const matrix<scalar_type>& b) {
    matrix<scalar_type> c(b);
    c.invert() *= a;
    return c;
}

template <typename scalar_type>
matrix<scalar_type> operator+(const matrix<scalar_type>& a,
                              const matrix<scalar_type>& b) {
    matrix<scalar_type> c(a);
    c += b;
    return c;
}

template <typename scalar_type>
matrix<scalar_type> operator-(const matrix<scalar_type>& a,
                              const matrix<scalar_type>& b) {
    matrix<scalar_type> c(a);
    c -= b;
    return c;
}

template <typename scalar_type>
matrix<scalar_type> operator*(const matrix<scalar_type>& a,
                              const matrix<scalar_type>& b) {
    matrix<scalar_type> c(a);
    c *= b;
    return c;
}

template <typename scalar_type>
matrix<scalar_type> operator/(const matrix<scalar_type>& a,
                              const matrix<scalar_type>& b) {
    matrix<scalar_type> c(a);
    c /= b;
    return c;
}

template <typename scalar_type>
void print(std::ostream& out, const matrix<scalar_type>& matrix) {
    out << '[';
    size_t rows = matrix.rows(), columns = matrix.columns();
    for (size_t row = 0; row < rows; ++row) {
        if (row > 0)
            out << ", ";
        out << '[';
        for (size_t column = 0; column < columns; ++column) {
            if (column > 0)
                out << ", ";
            out << matrix.at(row, column);
        }
        out << ']';
    }
    out << "]\n";
}

void test_matrix_matrix() {
    const size_t rows = 3, columns = 2;
    matrix<double> a(rows, columns);
    for (size_t i = 0; i < rows; ++i) {
        for (size_t j = 0; j < columns; ++j)
            a.at(i, j) = double(columns * i + j + 1);
    }
    matrix<double> b(a);

    std::cout << "a + b:\n";
    print(std::cout, a + b);

    std::cout << "\na - b:\n";
    print(std::cout, a - b);

    std::cout << "\na * b:\n";
    print(std::cout, a * b);

    std::cout << "\na / b:\n";
    print(std::cout, a / b);

    std::cout << "\npow(a, b):\n";
    print(std::cout, pow(a, b));
}

void test_matrix_scalar() {
    const size_t rows = 3, columns = 4;
    matrix<double> a(rows, columns);
    for (size_t i = 0; i < rows; ++i) {
        for (size_t j = 0; j < columns; ++j)
            a.at(i, j) = double(columns * i + j + 1);
    }

    std::cout << "a + 10:\n";
    print(std::cout, a + 10.0);

    std::cout << "\na - 10:\n";
    print(std::cout, a - 10.0);

    std::cout << "\n10 - a:\n";
    print(std::cout, 10.0 - a);

    std::cout << "\na * 10:\n";
    print(std::cout, a * 10.0);

    std::cout << "\na / 10:\n";
    print(std::cout, a / 10.0);

    std::cout << "\npow(a, 0.5):\n";
    print(std::cout, pow(a, 0.5));
}

int main() {
    test_matrix_matrix();
    std::cout << '\n';
    test_matrix_scalar();
    return 0;
}
