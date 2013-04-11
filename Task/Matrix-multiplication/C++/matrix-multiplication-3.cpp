#ifndef _MATRIX_H
#define	_MATRIX_H

#include <sstream>
#include <string>
#include <vector>

#define MATRIX_ERROR_CODE_COUNT 5
#define MATRIX_ERR_UNDEFINED "1 Undefined exception!"
#define MATRIX_ERR_WRONG_ROW_INDEX "2 The row index is out of range."
#define MATRIX_ERR_MUL_ROW_AND_COL_NOT_EQUAL "3 The row number of second matrix must be equal with the column number of first matrix!"
#define MATRIX_ERR_MUL_ROW_AND_COL_BE_GREATER_THAN_ZERO "4 The number of rows and columns must be greater than zero!"
#define MATRIX_ERR_TOO_FEW_DATA "5 Too few data in matrix."

class MatrixException {
private:
    std::string message_;
    int errorCode_;
public:
    MatrixException(std::string message = MATRIX_ERR_UNDEFINED);

    inline std::string message() {
        return message_;
    };

    inline int errorCode() {
        return errorCode_;
    };
};

MatrixException::MatrixException(std::string message) {
    errorCode_ = MATRIX_ERROR_CODE_COUNT + 1;
    std::stringstream ss(message);
    ss >> errorCode_;
    if (errorCode_ < 1) {
        errorCode_ = MATRIX_ERROR_CODE_COUNT + 1;
    }
    std::string::size_type pos = message.find(' ');
    if (errorCode_ <= MATRIX_ERROR_CODE_COUNT && pos != std::string::npos) {
        message_ = message.substr(pos + 1);
    } else {
        message_ = message + " (This an unknown and unsupported exception!)";
    }
}

/**
 * Generic class for matrices.
 */
template <class T>
class Matrix {
private:
    std::vector<T> v; // the data of matrix
    unsigned int m;   // the number of rows
    unsigned int n;   // the number of columns
protected:

    virtual void clear() {
        v.clear();
        m = n = 0;
    }
public:

    Matrix() {
        clear();
    }
    Matrix(unsigned int, unsigned int, T* = 0, unsigned int = 0);
    Matrix(unsigned int, unsigned int, const std::vector<T>&);

    virtual ~Matrix() {
        clear();
    }
    Matrix& operator=(const Matrix&);
    std::vector<T> operator[](unsigned int) const;
    Matrix operator*(const Matrix&);

    inline unsigned int rowNum() const {
        return m;
    }

    inline unsigned int colNum() const {
        return n;
    }

    inline unsigned int size() const {
        return v.size();
    }

    inline void add(const T& t) {
        v.push_back(t);
    }
};

template <class T>
Matrix<T>::Matrix(unsigned int row, unsigned int col, T* data, unsigned int dataLength) {
    clear();
    if (row > 0 && col > 0) {
        m = row;
        n = col;
        unsigned int mxn = m * n;
        if (dataLength && data) {
            for (unsigned int i = 0; i < dataLength && i < mxn; i++) {
                v.push_back(data[i]);
            }
        }
    }
}

template <class T>
Matrix<T>::Matrix(unsigned int row, unsigned int col, const std::vector<T>& data) {
    clear();
    if (row > 0 && col > 0) {
        m = row;
        n = col;
        unsigned int mxn = m * n;
        if (data.size() > 0) {
            for (unsigned int i = 0; i < mxn && i < data.size(); i++) {
                v.push_back(data[i]);
            }
        }
    }
}

template<class T>
Matrix<T>& Matrix<T>::operator=(const Matrix<T>& other) {
    clear();
    if (other.m > 0 && other.n > 0) {
        m = other.m;
        n = other.n;
        unsigned int mxn = m * n;
        for (unsigned int i = 0; i < mxn && i < other.size(); i++) {
            v.push_back(other.v[i]);
        }
    }
    return *this;
}

template<class T>
std::vector<T> Matrix<T>::operator[](unsigned int index) const {
    std::vector<T> result;
    if (index >= m) {
        throw MatrixException(MATRIX_ERR_WRONG_ROW_INDEX);
    } else if ((index + 1) * n > size()) {
        throw MatrixException(MATRIX_ERR_TOO_FEW_DATA);
    } else {
        unsigned int begin = index * n;
        unsigned int end = begin + n;
        for (unsigned int i = begin; i < end; i++) {
            result.push_back(v[i]);
        }
    }
    return result;
}

template<class T>
Matrix<T> Matrix<T>::operator*(const Matrix<T>& other) {
    Matrix result(m, other.n);
    if (n != other.m) {
        throw MatrixException(MATRIX_ERR_MUL_ROW_AND_COL_NOT_EQUAL);
    } else if (m <= 0 || n <= 0 || other.n <= 0) {
        throw MatrixException(MATRIX_ERR_MUL_ROW_AND_COL_BE_GREATER_THAN_ZERO);
    } else if (m * n > size() || other.m * other.n > other.size()) {
        throw MatrixException(MATRIX_ERR_TOO_FEW_DATA);
    } else {
        for (unsigned int i = 0; i < m; i++) {
            for (unsigned int j = 0; j < other.n; j++) {
                T temp = v[i * n] * other.v[j];
                for (unsigned int k = 1; k < n; k++) {
                    temp += v[i * n + k] * other.v[k * other.n + j];
                }
                result.v.push_back(temp);
            }
        }
    }
    return result;
}

#endif	/* _MATRIX_H */
