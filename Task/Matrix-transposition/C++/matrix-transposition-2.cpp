#include <iostream>
#include "matrix.h"

#if !defined(ARRAY_SIZE)
    #define ARRAY_SIZE(x) (sizeof((x)) / sizeof((x)[0]))
#endif

template<class T>
void printMatrix(const Matrix<T>& m) {
    std::cout << "rows = " << m.rowNum() << "   columns = " << m.colNum() << std::endl;
    for (unsigned int i = 0; i < m.rowNum(); i++) {
        for (unsigned int j = 0; j < m.colNum(); j++) {
            std::cout <<  m[i][j] << "  ";
        }
        std::cout << std::endl;
    }
} /* printMatrix() */

int main() {
    int  am[2][3] = {
        {1,2,3},
        {4,5,6},
    };

    Matrix<int> a(ARRAY_SIZE(am), ARRAY_SIZE(am[0]), am[0], ARRAY_SIZE(am)*ARRAY_SIZE(am[0]));

    try {
        std::cout << "Before transposition:" << std::endl;
        printMatrix(a);
        std::cout << std::endl;
        a.transpose();
        std::cout << "After transposition:" << std::endl;
        printMatrix(a);
    } catch (MatrixException& e) {
        std::cerr << e.message() << std::endl;
        return e.errorCode();
    }

} /* main() */
