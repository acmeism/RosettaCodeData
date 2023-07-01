#include <cassert>
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

// See https://en.wikipedia.org/wiki/Kronecker_product
template <typename scalar_type>
matrix<scalar_type> kronecker_product(const matrix<scalar_type>& a,
                                      const matrix<scalar_type>& b) {
    size_t arows = a.rows();
    size_t acolumns = a.columns();
    size_t brows = b.rows();
    size_t bcolumns = b.columns();
    matrix<scalar_type> c(arows * brows, acolumns * bcolumns);
    for (size_t i = 0; i < arows; ++i)
        for (size_t j = 0; j < acolumns; ++j)
            for (size_t k = 0; k < brows; ++k)
                for (size_t l = 0; l < bcolumns; ++l)
                    c(i*brows + k, j*bcolumns + l) = a(i, j) * b(k, l);
    return c;
}

template <typename scalar_type>
void print(std::wostream& out, const matrix<scalar_type>& a) {
    const wchar_t* box_top_left = L"\x250c";
    const wchar_t* box_top_right = L"\x2510";
    const wchar_t* box_bottom_left = L"\x2514";
    const wchar_t* box_bottom_right = L"\x2518";
    const wchar_t* box_vertical = L"\x2502";
    const wchar_t nl = L'\n';
    const wchar_t space = L' ';
    const int width = 2;

    size_t rows = a.rows(), columns = a.columns();
    std::wstring spaces((width + 1) * columns, space);
    out << box_top_left << spaces << box_top_right << nl;
    for (size_t row = 0; row < rows; ++row) {
        out << box_vertical;
        for (size_t column = 0; column < columns; ++column)
            out << std::setw(width) << a(row, column) << space;
        out << box_vertical << nl;
    }
    out << box_bottom_left << spaces << box_bottom_right << nl;
}

void test1() {
    matrix<int> matrix1(2, 2, {{1,2}, {3,4}});
    matrix<int> matrix2(2, 2, {{0,5}, {6,7}});
    std::wcout << L"Test case 1:\n";
    print(std::wcout, kronecker_product(matrix1, matrix2));
}

void test2() {
    matrix<int> matrix1(3, 3, {{0,1,0}, {1,1,1}, {0,1,0}});
    matrix<int> matrix2(3, 4, {{1,1,1,1}, {1,0,0,1}, {1,1,1,1}});
    std::wcout << L"Test case 2:\n";
    print(std::wcout, kronecker_product(matrix1, matrix2));
}

int main() {
    std::wcout.imbue(std::locale(""));
    test1();
    test2();
    return 0;
}
