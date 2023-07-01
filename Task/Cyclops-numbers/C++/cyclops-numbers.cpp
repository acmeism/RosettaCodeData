#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <vector>
#include <iomanip>
#include <cmath>

template <class T>
void print(std::vector< T >, size_t);

bool isCyclopsNumber(int);
std::vector< int > firstCyclops(int);
bool isPrime(int);
std::vector< int > firstCyclopsPrimes(int);
int blindCyclops(int);
std::vector< int > firstBlindCyclopsPrimes(int);
bool isPalindrome(int);
std::vector< int > firstPalindromeCyclopsPrimes(int);

int main(void) {
    auto first50 = firstCyclops(50);

    std::cout << "First 50 cyclops numbers:" << std::endl;
    print< int >(first50, 10);

    auto prime50 = firstCyclopsPrimes(50);

    std::cout << std::endl << "First 50 prime cyclops numbers:" << std::endl;
    print< int >(prime50, 10);

    auto blind50 = firstBlindCyclopsPrimes(50);

    std::cout << std::endl << "First 50 blind prime cyclops numbers:" << std::endl;
    print< int >(blind50, 10);

    auto palindrome50 = firstPalindromeCyclopsPrimes(50);

    std::cout << std::endl << "First 50 palindromic prime cyclops numbers:" << std::endl;
    print< int >(palindrome50, 10);

    return 0;
}

template <class T>
void print(std::vector< T > v, size_t nc) {
    size_t col = 0;
    for (auto e : v) {
        std::cout << std::setw(8) << e << "   ";
        col++;
        if (col == nc) {
            std::cout << std::endl;
            col = 0;
        }
    }
}

bool isCyclopsNumber(int n) {
    if (n == 0) {
        return true;
    }
    int m = n % 10;
    int count = 0;
    while (m != 0) {
        count++;
        n /= 10;
        m = n % 10;
    }
    n /= 10;
    m = n % 10;
    while (m != 0) {
        count--;
        n /= 10;
        m = n % 10;
    }
    return n == 0 && count == 0;
}

std::vector< int > firstCyclops(int n) {
    std::vector< int > result;
    int i = 0;
    while (result.size() < n) {
        if (isCyclopsNumber(i)) result.push_back(i);
        i++;
    }
    return result;
}

bool isPrime(int n) {
    if (n < 2) return false;
    double s = std::sqrt(n);
    for (int i = 2; i <= s; i++) {
        if (n % i == 0) {
            return false;
        }
    }
    return true;
}

std::vector< int > firstCyclopsPrimes(int n) {
    std::vector< int > result;
    int i = 0;
    while (result.size() < n) {
        if (isCyclopsNumber(i) && isPrime(i)) result.push_back(i);
        i++;
    }
    return result;
}

int blindCyclops(int n) {
    int m = n % 10;
    int k = 0;
    while (m != 0) {
        k = 10 * k + m;
        n /= 10;
        m = n % 10;
    }
    n /= 10;
    while (k != 0) {
        m = k % 10;
        n = 10 * n + m;
        k /= 10;
    }
    return n;
}

std::vector< int > firstBlindCyclopsPrimes(int n) {
    std::vector< int > result;
    int i = 0;
    while (result.size() < n) {
        if (isCyclopsNumber(i) && isPrime(i)) {
            int j = blindCyclops(i);
            if (isPrime(j)) result.push_back(i);
        }
        i++;
    }
    return result;
}

bool isPalindrome(int n) {
    int k = 0;
    int l = n;
    while (l != 0) {
        int m = l % 10;
        k = 10 * k + m;
        l /= 10;
    }
    return n == k;
}

std::vector< int > firstPalindromeCyclopsPrimes(int n) {
    std::vector< int > result;
    int i = 0;
    while (result.size() < n) {
        if (isCyclopsNumber(i) && isPrime(i) && isPalindrome(i)) result.push_back(i);
        i++;
    }
    return result;
}
