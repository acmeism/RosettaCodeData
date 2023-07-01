#include <algorithm>
#include <cassert>
#include <cmath>
#include <iomanip>
#include <iostream>
#include <vector>

template <typename scalar_type> class matrix {
public:
    matrix(size_t rows, size_t columns)
        : rows_(rows), columns_(columns), elements_(rows * columns) {}

    matrix(size_t rows, size_t columns,
        const std::initializer_list<std::initializer_list<scalar_type>>& values)
        : rows_(rows), columns_(columns), elements_(rows * columns) {
        assert(values.size() <= rows_);
        auto i = elements_.begin();
        for (const auto& row : values) {
            assert(row.size() <= columns_);
            std::copy(begin(row), end(row), i);
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
void swap_rows(matrix<scalar_type>& m, size_t i, size_t j) {
    size_t columns = m.columns();
    for (size_t k = 0; k < columns; ++k)
        std::swap(m(i, k), m(j, k));
}

template <typename scalar_type>
std::vector<scalar_type> gauss_partial(const matrix<scalar_type>& a0,
                                       const std::vector<scalar_type>& b0) {
    size_t n = a0.rows();
    assert(a0.columns() == n);
    assert(b0.size() == n);
    // make augmented matrix
    matrix<scalar_type> a(n, n + 1);
    for (size_t i = 0; i < n; ++i) {
        for (size_t j = 0; j < n; ++j)
            a(i, j) = a0(i, j);
        a(i, n) = b0[i];
    }
    // WP algorithm from Gaussian elimination page
    // produces row echelon form
    for (size_t k = 0; k < n; ++k) {
        // Find pivot for column k
        size_t max_index = k;
        scalar_type max_value = 0;
        for (size_t i = k; i < n; ++i) {
            // compute scale factor = max abs in row
            scalar_type scale_factor = 0;
            for (size_t j = k; j < n; ++j)
                scale_factor = std::max(std::abs(a(i, j)), scale_factor);
            if (scale_factor == 0)
                continue;
            // scale the abs used to pick the pivot
            scalar_type abs = std::abs(a(i, k))/scale_factor;
            if (abs > max_value) {
                max_index = i;
                max_value = abs;
            }
        }
        if (a(max_index, k) == 0)
            throw std::runtime_error("matrix is singular");
        if (k != max_index)
            swap_rows(a, k, max_index);
        for (size_t i = k + 1; i < n; ++i) {
            scalar_type f = a(i, k)/a(k, k);
            for (size_t j = k + 1; j <= n; ++j)
                a(i, j) -= a(k, j) * f;
            a(i, k) = 0;
        }
    }
    // now back substitute to get result
    std::vector<scalar_type> x(n);
    for (size_t i = n; i-- > 0; ) {
        x[i] = a(i, n);
        for (size_t j = i + 1; j < n; ++j)
            x[i] -= a(i, j) * x[j];
        x[i] /= a(i, i);
    }
    return x;
}

int main() {
    matrix<double> a(6, 6, {
        {1.00, 0.00, 0.00, 0.00, 0.00, 0.00},
        {1.00, 0.63, 0.39, 0.25, 0.16, 0.10},
        {1.00, 1.26, 1.58, 1.98, 2.49, 3.13},
        {1.00, 1.88, 3.55, 6.70, 12.62, 23.80},
        {1.00, 2.51, 6.32, 15.88, 39.90, 100.28},
        {1.00, 3.14, 9.87, 31.01, 97.41, 306.02}
    });
    std::vector<double> b{-0.01, 0.61, 0.91, 0.99, 0.60, 0.02};
    std::vector<double> x{-0.01, 1.602790394502114, -1.6132030599055613,
            1.2454941213714368, -0.4909897195846576, 0.065760696175232};
    std::vector<double> y(gauss_partial(a, b));
    std::cout << std::setprecision(16);
    const double epsilon = 1e-14;
    for (size_t i = 0; i < y.size(); ++i) {
        assert(std::abs(x[i] - y[i]) <= epsilon);
        std::cout << y[i] << '\n';
    }
    return 0;
}
