#include <iostream>
#include <vector>

typedef std::vector<std::vector<int>> vv;

vv pascal_upper(int n) {
    vv matrix(n);
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
                if (i > j) matrix[i].push_back(0);
                else if (i == j || i == 0) matrix[i].push_back(1);
                else matrix[i].push_back(matrix[i - 1][j - 1] + matrix[i][j - 1]);
            }
        }
        return matrix;
    }

vv pascal_lower(int n) {
    vv matrix(n);
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            if (i < j) matrix[i].push_back(0);
            else if (i == j || j == 0) matrix[i].push_back(1);
            else matrix[i].push_back(matrix[i - 1][j - 1] + matrix[i - 1][j]);
        }
    }
    return matrix;
}

vv pascal_symmetric(int n) {
    vv matrix(n);
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            if (i == 0 || j == 0) matrix[i].push_back(1);
            else matrix[i].push_back(matrix[i][j - 1] + matrix[i - 1][j]);
        }
    }
    return matrix;
}


void print_matrix(vv matrix) {
    for (std::vector<int> v: matrix) {
        for (int i: v) {
            std::cout << " " << i;
        }
        std::cout << std::endl;
    }
}

int main() {
    std::cout << "PASCAL UPPER MATRIX" << std::endl;
    print_matrix(pascal_upper(5));
    std::cout << "PASCAL LOWER MATRIX" << std::endl;
    print_matrix(pascal_lower(5));
    std::cout << "PASCAL SYMMETRIC MATRIX" << std::endl;
    print_matrix(pascal_symmetric(5));
}
