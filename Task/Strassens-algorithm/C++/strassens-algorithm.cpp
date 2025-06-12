#include <iostream>
#include <vector>
#include <iomanip>
#include <cmath>
#include <sstream>
#include <stdexcept>

class Matrix {
public:
    std::vector<std::vector<double>> data;
    size_t rows;
    size_t cols;

    Matrix(const std::vector<std::vector<double>>& data) : data(data) {
        rows = data.size();
        cols = (rows > 0) ? data[0].size() : 0;
    }

    size_t getRows() const {
        return rows;
    }

    size_t getCols() const {
        return cols;
    }

    void validateDimensions(const Matrix& other) const {
        if (getRows() != other.getRows() || getCols() != other.getCols()) {
            throw std::runtime_error("Matrices must have the same dimensions.");
        }
    }

    void validateMultiplication(const Matrix& other) const {
        if (getCols() != other.getRows()) {
            throw std::runtime_error("Cannot multiply these matrices.");
        }
    }

    void validateSquarePowerOfTwo() const {
        if (getRows() != getCols()) {
            throw std::runtime_error("Matrix must be square.");
        }
        if (getRows() == 0 || (getRows() & (getRows() - 1)) != 0) {
            throw std::runtime_error("Size of matrix must be a power of two.");
        }
    }

    Matrix operator+(const Matrix& other) const {
        validateDimensions(other);

        std::vector<std::vector<double>> result_data(rows, std::vector<double>(cols));
        for (size_t i = 0; i < rows; ++i) {
            for (size_t j = 0; j < cols; ++j) {
                result_data[i][j] = data[i][j] + other.data[i][j];
            }
        }

        return Matrix(result_data);
    }

    Matrix operator-(const Matrix& other) const {
        validateDimensions(other);

        std::vector<std::vector<double>> result_data(rows, std::vector<double>(cols));
        for (size_t i = 0; i < rows; ++i) {
            for (size_t j = 0; j < cols; ++j) {
                result_data[i][j] = data[i][j] - other.data[i][j];
            }
        }

        return Matrix(result_data);
    }

    Matrix operator*(const Matrix& other) const {
        validateMultiplication(other);

        std::vector<std::vector<double>> result_data(rows, std::vector<double>(other.cols));
        for (size_t i = 0; i < rows; ++i) {
            for (size_t j = 0; j < other.cols; ++j) {
                double sum = 0.0;
                for (size_t k = 0; k < other.rows; ++k) {
                    sum += data[i][k] * other.data[k][j];
                }
                result_data[i][j] = sum;
            }
        }

        return Matrix(result_data);
    }

    friend std::ostream& operator<<(std::ostream& os, const Matrix& matrix) {
        for (const auto& row : matrix.data) {
            os << "[";
            for (size_t i = 0; i < row.size(); ++i) {
                os << row[i];
                if (i < row.size() - 1) {
                    os << ", ";
                }
            }
            os << "]" << std::endl;
        }
        return os;
    }

    std::string toStringWithPrecision(size_t p) const {
        std::stringstream ss;
        ss << std::fixed << std::setprecision(p);
        double pow = std::pow(10.0, p);

        for (const auto& row : data) {
            ss << "[";
            for (size_t i = 0; i < row.size(); ++i) {
                double r = std::round(row[i] * pow) / pow;
                std::string formatted = ss.str();
                ss.str(std::string());
                ss << r;
                formatted = ss.str();

                if (formatted == "-0") {
                    ss.str(std::string());
                    ss << "0";
                    formatted = ss.str();
                }

                ss.str(std::string());
                ss << formatted;

                if (i < row.size() - 1) {
                     ss << ", ";
                }
            }
            ss << "]" << std::endl;

        }
        return ss.str();
    }

    static std::array<std::array<size_t, 6>, 4> params(size_t r, size_t c) {
      return {
          {{{0, r, 0, c, 0, 0}},
           {{0, r, c, 2 * c, 0, c}},
           {{r, 2 * r, 0, c, r, 0}},
           {{r, 2 * r, c, 2 * c, r, c}}}
      };
    }

    std::array<Matrix, 4> toQuarters() const {
        size_t r = getRows() / 2;
        size_t c = getCols() / 2;
        auto p = Matrix::params(r, c);
        std::array<Matrix, 4> quarters = {
            Matrix(std::vector<std::vector<double>>(r, std::vector<double>(c, 0.0))),
            Matrix(std::vector<std::vector<double>>(r, std::vector<double>(c, 0.0))),
            Matrix(std::vector<std::vector<double>>(r, std::vector<double>(c, 0.0))),
            Matrix(std::vector<std::vector<double>>(r, std::vector<double>(c, 0.0)))
        };

        for (size_t k = 0; k < 4; ++k) {
            std::vector<std::vector<double>> q_data(r, std::vector<double>(c));
            for (size_t i = p[k][0]; i < p[k][1]; ++i) {
                for (size_t j = p[k][2]; j < p[k][3]; ++j) {
                    q_data[i - p[k][4]][j - p[k][5]] = data[i][j];
                }
            }
            quarters[k] = Matrix(q_data);
        }

        return quarters;
    }

    static Matrix fromQuarters(const std::array<Matrix, 4>& q) {
        size_t r = q[0].getRows();
        size_t c = q[0].getCols();
        auto p = Matrix::params(r, c);
        size_t rows = r * 2;
        size_t cols = c * 2;

        std::vector<std::vector<double>> m_data(rows, std::vector<double>(cols, 0.0));

        for (size_t k = 0; k < 4; ++k) {
            for (size_t i = p[k][0]; i < p[k][1]; ++i) {
                for (size_t j = p[k][2]; j < p[k][3]; ++j) {
                    m_data[i][j] = q[k].data[i - p[k][4]][j - p[k][5]];
                }
            }
        }

        return Matrix(m_data);
    }

    Matrix strassen(const Matrix& other) const {
        validateSquarePowerOfTwo();
        other.validateSquarePowerOfTwo();
        if (getRows() != other.getRows() || getCols() != other.getCols()) {
            throw std::runtime_error("Matrices must be square and of equal size for Strassen multiplication.");
        }

        if (getRows() == 1) {
            return *this * other;
        }

        auto qa = toQuarters();
        auto qb = other.toQuarters();

        Matrix p1 = (qa[1] - qa[3]).strassen(qb[2] + qb[3]);
        Matrix p2 = (qa[0] + qa[3]).strassen(qb[0] + qb[3]);
        Matrix p3 = (qa[0] - qa[2]).strassen(qb[0] + qb[1]);
        Matrix p4 = (qa[0] + qa[1]).strassen(qb[3]);
        Matrix p5 = qa[0].strassen(qb[1] - qb[3]);
        Matrix p6 = qa[3].strassen(qb[2] - qb[0]);
        Matrix p7 = (qa[2] + qa[3]).strassen(qb[0]);

        std::array<Matrix, 4> q = {
            Matrix(std::vector<std::vector<double>>(qa[0].getRows(), std::vector<double>(qa[0].getCols(), 0.0))),
            Matrix(std::vector<std::vector<double>>(qa[0].getRows(), std::vector<double>(qa[0].getCols(), 0.0))),
            Matrix(std::vector<std::vector<double>>(qa[0].getRows(), std::vector<double>(qa[0].getCols(), 0.0))),
            Matrix(std::vector<std::vector<double>>(qa[0].getRows(), std::vector<double>(qa[0].getCols(), 0.0)))
        };

        q[0] = p1 + p2 - p4 + p6;
        q[1] = p4 + p5;
        q[2] = p6 + p7;
        q[3] = p2 - p3 + p5 - p7;

        return Matrix::fromQuarters(q);
    }
};

int main() {
    Matrix a({ {1.0, 2.0}, {3.0, 4.0} });
    Matrix b({ {5.0, 6.0}, {7.0, 8.0} });
    Matrix c({ {1.0, 1.0, 1.0, 1.0}, {2.0, 4.0, 8.0, 16.0}, {3.0, 9.0, 27.0, 81.0}, {4.0, 16.0, 64.0, 256.0} });
    Matrix d({ {4.0, -3.0, 4.0 / 3.0, -1.0 / 4.0}, {-13.0 / 3.0, 19.0 / 4.0, -7.0 / 3.0, 11.0 / 24.0}, {3.0 / 2.0, -2.0, 7.0 / 6.0, -1.0 / 4.0}, {-1.0 / 6.0, 1.0 / 4.0, -1.0 / 6.0, 1.0 / 24.0} });
    Matrix e({ {1.0, 2.0, 3.0, 4.0}, {5.0, 6.0, 7.0, 8.0}, {9.0, 10.0, 11.0, 12.0}, {13.0, 14.0, 15.0, 16.0} });
    Matrix f({ {1.0, 0.0, 0.0, 0.0}, {0.0, 1.0, 0.0, 0.0}, {0.0, 0.0, 1.0, 0.0}, {0.0, 0.0, 0.0, 1.0} });

    std::cout << "Using 'normal' matrix multiplication:" << std::endl;
    std::cout << "  a * b = " << a * b << std::endl;
    std::cout << "  c * d = " << (c * d).toStringWithPrecision(6) << std::endl;
    std::cout << "  e * f = " << e * f << std::endl;

    std::cout << "\nUsing 'Strassen' matrix multiplication:" << std::endl;
    std::cout << "  a * b = " << a.strassen(b) << std::endl;
    std::cout << "  c * d = " << c.strassen(d).toStringWithPrecision(6) << std::endl;
    std::cout << "  e * f = " << e.strassen(f) << std::endl;

    return 0;
}
