// Compile with:
// g++ -std=c++20 -Wall -Wextra -pedantic DividuusNumbers.cpp -o DividuusNumbers -fopenmp

#include <functional>
#include <iostream>
#include <numeric>
#include <sstream>
#include <string>
#include <vector>

template <typename T>
std::string vectorRepr(const std::vector<T> &vector) {
    std::ostringstream result;

    for (size_t i = 0; i < vector.size(); ++i) {
        if (i != 0)
            result << ", ";
        result << vector[i];
    }

    return result.str();
}

int sumOfDigits(int n) {
    const std::string numString = std::to_string(n);
    std::vector<int> digits(numString.size());

    std::transform(
        numString.begin(), numString.end(), digits.begin(),
        [](char c) {
            return c - '0';
        }
    );
    int sum = std::accumulate(digits.begin(), digits.end(), 0);

    return sum;
}

int productOfDigits(int n) {
    const std::string numString = std::to_string(n);
    std::vector<int> digits(numString.size());

    std::transform(
        numString.begin(), numString.end(), digits.begin(),
        [](char c) {
            return c - '0';
        }
    );
    int product = std::accumulate(digits.begin(), digits.end(), 1, std::multiplies<int>());

    return product;
}

int digitalRoot(int n) {
    int sum = sumOfDigits(n);
    return sum < 10 ? sum : digitalRoot(sum);
}

int multiplicativeDigitalRoot(int n) {
    int product = productOfDigits(n);
    return product < 10 ? product : multiplicativeDigitalRoot(product);
}

bool isDividuus(int n) {
    if (!(
        digitalRoot(n) != 0
        && multiplicativeDigitalRoot(n) != 0
        && n % sumOfDigits(n) == 0
        && n % productOfDigits(n) == 0
        && n % digitalRoot(n) == 0
        && n % multiplicativeDigitalRoot(n) == 0
    ))
        return false;
    return true;
}

int main() {
    std::vector<int> count;

    int i = 1;
    while (count.size() < 50) {
        if (isDividuus(i))
            count.push_back(i);
        i++;
    }

    std::cout << "First fifty Dividuus numbers:\n" << vectorRepr(count) << "\n";

    count.clear();

    #pragma omp parallel for
    for (int i = 990000000; i <= 1000000000; i++)
        if (isDividuus(i))
            count.push_back(i);

    std::cout << "Dividuus numbers between 990,000,000 and 1,000,000,000:\n" << vectorRepr(count) << "\n";

    return 0;
}
