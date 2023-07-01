#include <cassert>
#include <cmath>
#include <iomanip>
#include <iostream>
#include <vector>

template <typename scalar_type> class matrix {
public:
    matrix(size_t rows, size_t columns)
        : rows_(rows), columns_(columns), elements_(rows * columns) {}

    matrix(size_t rows, size_t columns, scalar_type value)
        : rows_(rows), columns_(columns), elements_(rows * columns, value) {}

    matrix(size_t rows, size_t columns,
        const std::initializer_list<std::initializer_list<scalar_type>>& values)
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

    const scalar_type& operator()(size_t row, size_t column) const {
        assert(row < rows_);
        assert(column < columns_);
        return elements_[row * columns_ + column];
    }
    scalar_type& operator()(size_t row, size_t column) {
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
void print(std::ostream& out, const matrix<scalar_type>& a) {
    size_t rows = a.rows(), columns = a.columns();
    out << std::fixed << std::setprecision(5);
    for (size_t row = 0; row < rows; ++row) {
        for (size_t column = 0; column < columns; ++column) {
            if (column > 0)
                out << ' ';
            out << std::setw(9) << a(row, column);
        }
        out << '\n';
    }
}

template <typename scalar_type>
matrix<scalar_type> cholesky_factor(const matrix<scalar_type>& input) {
    assert(input.rows() == input.columns());
    size_t n = input.rows();
    matrix<scalar_type> result(n, n);
    for (size_t i = 0; i < n; ++i) {
        for (size_t k = 0; k < i; ++k) {
            scalar_type value = input(i, k);
            for (size_t j = 0; j < k; ++j)
                value -= result(i, j) * result(k, j);
            result(i, k) = value/result(k, k);
        }
        scalar_type value = input(i, i);
        for (size_t j = 0; j < i; ++j)
            value -= result(i, j) * result(i, j);
        result(i, i) = std::sqrt(value);
    }
    return result;
}

void print_cholesky_factor(const matrix<double>& matrix) {
    std::cout << "Matrix:\n";
    print(std::cout, matrix);
    std::cout << "Cholesky factor:\n";
    print(std::cout, cholesky_factor(matrix));
}

int main() {
    matrix<double> matrix1(3, 3,
       {{25, 15, -5},
        {15, 18, 0},
        {-5, 0, 11}});
    print_cholesky_factor(matrix1);

    matrix<double> matrix2(4, 4,
       {{18, 22, 54, 42},
        {22, 70, 86, 62},
        {54, 86, 174, 134},
        {42, 62, 134, 106}});
    print_cholesky_factor(matrix2);

    return 0;
}
