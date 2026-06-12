#include <iostream>
#include <vector>
#include <algorithm>
#include <random>
#include <string>

void shuffle(std::vector<int>& array) {
    std::random_device rd;
    std::mt19937 g(rd());
    std::shuffle(array.begin(), array.end(), g);
}

bool countdown(std::vector<int> numbers, int target) {
    if (numbers.size() <= 1) {
        return false;
    }

    for (size_t i = 0; i < numbers.size(); i++) {
        int n0 = numbers[i];
        std::vector<int> numbers1;
        for (size_t k = 0; k < numbers.size(); k++) {
            if (k != i) {
                numbers1.push_back(numbers[k]);
            }
        }

        for (size_t j = 0; j < numbers1.size(); j++) {
            int n1 = numbers1[j];
            std::vector<int> numbers2;
            for (size_t k = 0; k < numbers1.size(); k++) {
                if (k != j) {
                    numbers2.push_back(numbers1[k]);
                }
            }

            if (n1 >= n0) {
                // Addition
                int result = n1 + n0;
                std::vector<int> numbersNext = numbers2;
                numbersNext.push_back(result);
                if (result == target || countdown(numbersNext, target)) {
                    std::cout << result << " = " << n1 << " + " << n0 << std::endl;
                    return true;
                }

                // Multiplication
                if (n0 != 1) {
                    result = n1 * n0;
                    numbersNext = numbers2;
                    numbersNext.push_back(result);
                    if (result == target || countdown(numbersNext, target)) {
                        std::cout << result << " = " << n1 << " * " << n0 << std::endl;
                        return true;
                    }
                }

                // Subtraction
                if (n1 != n0) {
                    result = n1 - n0;
                    numbersNext = numbers2;
                    numbersNext.push_back(result);
                    if (result == target || countdown(numbersNext, target)) {
                        std::cout << result << " = " << n1 << " - " << n0 << std::endl;
                        return true;
                    }
                }

                // Division
                if (n0 != 1 && n1 % n0 == 0) {
                    result = n1 / n0;
                    numbersNext = numbers2;
                    numbersNext.push_back(result);
                    if (result == target || countdown(numbersNext, target)) {
                        std::cout << result << " = " << n1 << " / " << n0 << std::endl;
                        return true;
                    }
                }
            }
        }
    }
    return false;
}

int main() {
    std::vector<int> allNumbers = {
        1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 25, 50, 75, 100
    };

    shuffle(allNumbers);

    std::vector<std::vector<int>> numberLists = {
        {3, 6, 25, 50, 75, 100},
        {100, 75, 50, 25, 6, 3},
        {8, 4, 4, 6, 8, 9},
        {allNumbers.begin(), allNumbers.begin() + 6}
    };

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(101, 999);

    std::vector<int> targetList = {952, 952, 594, dis(gen)};

    for (size_t i = 0; i < targetList.size(); i++) {
        std::cout << "Using : [";
        for (size_t j = 0; j < numberLists[i].size(); j++) {
            std::cout << numberLists[i][j];
            if (j < numberLists[i].size() - 1) {
                std::cout << ", ";
            }
        }
        std::cout << "]" << std::endl;

        std::cout << "Target: " << targetList[i] << std::endl;
        bool done = countdown(numberLists[i], targetList[i]);
        if (!done) {
            std::cout << "No solution found" << std::endl;
        }
        std::cout << std::endl;
    }

    return 0;
}
