#include <cassert>
#include <vector>

#include <QImage>

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

bool kronecker_fractal(const char* fileName, const matrix<unsigned char>& m, int order) {
    matrix<unsigned char> result = m;
    for (int i = 0; i < order; ++i)
        result = kronecker_product(result, m);

    size_t height = result.rows();
    size_t width = result.columns();
    size_t bytesPerLine = 4 * ((width + 3)/4);
    std::vector<uchar> imageData(bytesPerLine * height);

    for (size_t i = 0; i < height; ++i)
        for (size_t j = 0; j < width; ++j)
            imageData[i * bytesPerLine + j] = result(i, j);

    QImage image(&imageData[0], width, height, bytesPerLine, QImage::Format_Indexed8);
    QVector<QRgb> colours(2);
    colours[0] = qRgb(0, 0, 0);
    colours[1] = qRgb(255, 255, 255);
    image.setColorTable(colours);
    return image.save(fileName);
}

int main() {
    matrix<unsigned char> matrix1(3, 3, {{0,1,0}, {1,1,1}, {0,1,0}});
    matrix<unsigned char> matrix2(3, 3, {{1,1,1}, {1,0,1}, {1,1,1}});
    matrix<unsigned char> matrix3(2, 2, {{1,1}, {0,1}});
    kronecker_fractal("vicsek.png", matrix1, 5);
    kronecker_fractal("sierpinski_carpet.png", matrix2, 5);
    kronecker_fractal("sierpinski_triangle.png", matrix3, 8);
    return 0;
}
