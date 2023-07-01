#include <iostream>
#include <vector>

template<typename T>
T sum_below_diagonal(const std::vector<std::vector<T>>& matrix) {
    T sum = 0;
    for (std::size_t y = 0; y < matrix.size(); y++)
        for (std::size_t x = 0; x < matrix[y].size() && x < y; x++)
            sum += matrix[y][x];
    return sum;
}

int main() {
    std::vector<std::vector<int>> matrix = {
        {1,3,7,8,10},
        {2,4,16,14,4},
        {3,1,9,18,11},
        {12,14,17,18,20},
        {7,1,3,9,5}
    };

    std::cout << sum_below_diagonal(matrix) << std::endl;
    return 0;
}
