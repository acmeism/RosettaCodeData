#include <Eigen/Dense>
#include <cstdlib>
#include <iomanip>
#include <iostream>

int main() {
    using namespace Eigen;
    int rows, columns;
    if (!(std::cin >> rows >> columns))
        return EXIT_FAILURE;
    MatrixXd matrix(rows, columns);
    for (int row = 0; row < rows; ++row) {
        for (int column = 0; column < columns; ++column) {
            if (!(std::cin >> matrix(row, column)))
                return EXIT_FAILURE;
        }
    }
    auto svd = matrix.bdcSvd().compute(matrix, ComputeFullU | ComputeFullV);
    std::cout << std::setprecision(15) << std::fixed << svd.matrixU() << "\n\n"
              << svd.singularValues() << "\n\n"
              << svd.matrixV() << '\n';
    return EXIT_SUCCESS;
}
