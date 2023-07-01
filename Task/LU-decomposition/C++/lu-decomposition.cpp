#include <cassert>
#include <cmath>
#include <iomanip>
#include <iostream>
#include <limits>
#include <numeric>
#include <sstream>
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
void print(std::wostream& out, const matrix<scalar_type>& a) {
    const wchar_t* box_top_left = L"\x23a1";
    const wchar_t* box_top_right = L"\x23a4";
    const wchar_t* box_left = L"\x23a2";
    const wchar_t* box_right = L"\x23a5";
    const wchar_t* box_bottom_left = L"\x23a3";
    const wchar_t* box_bottom_right = L"\x23a6";

    const int precision = 5;
    size_t rows = a.rows(), columns = a.columns();
    std::vector<size_t> width(columns);
    for (size_t column = 0; column < columns; ++column) {
        size_t max_width = 0;
        for (size_t row = 0; row < rows; ++row) {
            std::ostringstream str;
            str << std::fixed << std::setprecision(precision) << a(row, column);
            max_width = std::max(max_width, str.str().length());
        }
        width[column] = max_width;
    }
    out << std::fixed << std::setprecision(precision);
    for (size_t row = 0; row < rows; ++row) {
        const bool top(row == 0), bottom(row + 1 == rows);
        out << (top ? box_top_left : (bottom ? box_bottom_left : box_left));
        for (size_t column = 0; column < columns; ++column) {
            if (column > 0)
                out << L' ';
            out << std::setw(width[column]) << a(row, column);
        }
        out << (top ? box_top_right : (bottom ? box_bottom_right : box_right));
        out << L'\n';
    }
}

// Return value is a tuple with elements (lower, upper, pivot)
template <typename scalar_type>
auto lu_decompose(const matrix<scalar_type>& input) {
    assert(input.rows() == input.columns());
    size_t n = input.rows();
    std::vector<size_t> perm(n);
    std::iota(perm.begin(), perm.end(), 0);
    matrix<scalar_type> lower(n, n);
    matrix<scalar_type> upper(n, n);
    matrix<scalar_type> input1(input);
    for (size_t j = 0; j < n; ++j) {
        size_t max_index = j;
        scalar_type max_value = 0;
        for (size_t i = j; i < n; ++i) {
            scalar_type value = std::abs(input1(perm[i], j));
            if (value > max_value) {
                max_index = i;
                max_value = value;
            }
        }
        if (max_value <= std::numeric_limits<scalar_type>::epsilon())
            throw std::runtime_error("matrix is singular");
        if (j != max_index)
            std::swap(perm[j], perm[max_index]);
        size_t jj = perm[j];
        for (size_t i = j + 1; i < n; ++i) {
            size_t ii = perm[i];
            input1(ii, j) /= input1(jj, j);
            for (size_t k = j + 1; k < n; ++k)
                input1(ii, k) -= input1(ii, j) * input1(jj, k);
        }
    }

    for (size_t j = 0; j < n; ++j) {
        lower(j, j) = 1;
        for (size_t i = j + 1; i < n; ++i)
            lower(i, j) = input1(perm[i], j);
        for (size_t i = 0; i <= j; ++i)
            upper(i, j) = input1(perm[i], j);
    }

    matrix<scalar_type> pivot(n, n);
    for (size_t i = 0; i < n; ++i)
        pivot(i, perm[i]) = 1;

    return std::make_tuple(lower, upper, pivot);
}

template <typename scalar_type>
void show_lu_decomposition(const matrix<scalar_type>& input) {
    try {
        std::wcout << L"A\n";
        print(std::wcout, input);
        auto result(lu_decompose(input));
        std::wcout << L"\nL\n";
        print(std::wcout, std::get<0>(result));
        std::wcout << L"\nU\n";
        print(std::wcout, std::get<1>(result));
        std::wcout << L"\nP\n";
        print(std::wcout, std::get<2>(result));
    } catch (const std::exception& ex) {
        std::cerr << ex.what() << '\n';
    }
}

int main() {
    std::wcout.imbue(std::locale(""));
    std::wcout << L"Example 1:\n";
    matrix<double> matrix1(3, 3,
       {{1, 3, 5},
        {2, 4, 7},
        {1, 1, 0}});
    show_lu_decomposition(matrix1);
    std::wcout << '\n';

    std::wcout << L"Example 2:\n";
    matrix<double> matrix2(4, 4,
      {{11, 9, 24, 2},
        {1, 5, 2, 6},
        {3, 17, 18, 1},
        {2, 5, 7, 1}});
    show_lu_decomposition(matrix2);
    std::wcout << '\n';

    std::wcout << L"Example 3:\n";
    matrix<double> matrix3(3, 3,
      {{-5, -6, -3},
       {-1,  0, -2},
       {-3, -4, -7}});
    show_lu_decomposition(matrix3);
    std::wcout << '\n';

    std::wcout << L"Example 4:\n";
    matrix<double> matrix4(3, 3,
      {{1, 2, 3},
       {4, 5, 6},
       {7, 8, 9}});
    show_lu_decomposition(matrix4);

    return 0;
}
