#include <algorithm>
#include <cassert>
#include <iomanip>
#include <iostream>
#include <vector>

template <typename scalar_type> class matrix {
public:
    matrix(size_t rows, size_t columns)
        : rows_(rows), columns_(columns), elements_(rows * columns) {}

    matrix(size_t rows, size_t columns, scalar_type value)
        : rows_(rows), columns_(columns), elements_(rows * columns, value) {}

    matrix(size_t rows, size_t columns, std::initializer_list<scalar_type> values)
        : rows_(rows), columns_(columns), elements_(rows * columns) {
        assert(values.size() <= rows_ * columns_);
        std::copy(values.begin(), values.end(), elements_.begin());
    }

    size_t rows() const { return rows_; }
    size_t columns() const { return columns_; }

    scalar_type& operator()(size_t row, size_t column) {
        assert(row < rows_);
        assert(column < columns_);
        return elements_[row * columns_ + column];
    }
    const scalar_type& operator()(size_t row, size_t column) const {
        assert(row < rows_);
        assert(column < columns_);
        return elements_[row * columns_ + column];
    }
private:
    size_t rows_;
    size_t columns_;
    std::vector<scalar_type> elements_;
};

template <typename scalar_type>
matrix<scalar_type> product(const matrix<scalar_type>& a,
                            const matrix<scalar_type>& b) {
    assert(a.columns() == b.rows());
    size_t arows = a.rows();
    size_t bcolumns = b.columns();
    size_t n = a.columns();
    matrix<scalar_type> c(arows, bcolumns);
    for (size_t i = 0; i < arows; ++i) {
        for (size_t j = 0; j < n; ++j) {
            for (size_t k = 0; k < bcolumns; ++k)
                c(i, k) += a(i, j) * b(j, k);
        }
    }
    return c;
}

template <typename scalar_type>
void swap_rows(matrix<scalar_type>& m, size_t i, size_t j) {
    size_t columns = m.columns();
    for (size_t column = 0; column < columns; ++column)
        std::swap(m(i, column), m(j, column));
}

// Convert matrix to reduced row echelon form
template <typename scalar_type>
void rref(matrix<scalar_type>& m) {
    size_t rows = m.rows();
    size_t columns = m.columns();
    for (size_t row = 0, lead = 0; row < rows && lead < columns; ++row, ++lead) {
        size_t i = row;
        while (m(i, lead) == 0) {
            if (++i == rows) {
                i = row;
                if (++lead == columns)
                    return;
            }
        }
        swap_rows(m, i, row);
        if (m(row, lead) != 0) {
            scalar_type f = m(row, lead);
            for (size_t column = 0; column < columns; ++column)
                m(row, column) /= f;
        }
        for (size_t j = 0; j < rows; ++j) {
            if (j == row)
                continue;
            scalar_type f = m(j, lead);
            for (size_t column = 0; column < columns; ++column)
                m(j, column) -= f * m(row, column);
        }
    }
}

template <typename scalar_type>
matrix<scalar_type> inverse(const matrix<scalar_type>& m) {
    assert(m.rows() == m.columns());
    size_t rows = m.rows();
    matrix<scalar_type> tmp(rows, 2 * rows, 0);
    for (size_t row = 0; row < rows; ++row) {
        for (size_t column = 0; column < rows; ++column)
            tmp(row, column) = m(row, column);
        tmp(row, row + rows) = 1;
    }
    rref(tmp);
    matrix<scalar_type> inv(rows, rows);
    for (size_t row = 0; row < rows; ++row) {
        for (size_t column = 0; column < rows; ++column)
            inv(row, column) = tmp(row, column + rows);
    }
    return inv;
}

template <typename scalar_type>
void print(std::ostream& out, const matrix<scalar_type>& m) {
    size_t rows = m.rows(), columns = m.columns();
    out << std::fixed << std::setprecision(4);
    for (size_t row = 0; row < rows; ++row) {
        for (size_t column = 0; column < columns; ++column) {
            if (column > 0)
                out << ' ';
            out << std::setw(7) << m(row, column);
        }
        out << '\n';
    }
}

int main() {
    matrix<double> m(3, 3, {2, -1, 0, -1, 2, -1, 0, -1, 2});
    std::cout << "Matrix:\n";
    print(std::cout, m);
    auto inv(inverse(m));
    std::cout << "Inverse:\n";
    print(std::cout, inv);
    std::cout << "Product of matrix and inverse:\n";
    print(std::cout, product(m, inv));
    std::cout << "Inverse of inverse:\n";
    print(std::cout, inverse(inv));
    return 0;
}
