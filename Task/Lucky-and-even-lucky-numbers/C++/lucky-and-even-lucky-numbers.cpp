#include <algorithm>
#include <iostream>
#include <iterator>
#include <vector>

const int luckySize = 60000;
std::vector<int> luckyEven(luckySize);
std::vector<int> luckyOdd(luckySize);

void init() {
    for (int i = 0; i < luckySize; ++i) {
        luckyEven[i] = i * 2 + 2;
        luckyOdd[i] = i * 2 + 1;
    }
}

void filterLuckyEven() {
    for (size_t n = 2; n < luckyEven.size(); ++n) {
        int m = luckyEven[n - 1];
        int end = (luckyEven.size() / m) * m - 1;
        for (int j = end; j >= m - 1; j -= m) {
            std::copy(luckyEven.begin() + j + 1, luckyEven.end(), luckyEven.begin() + j);
            luckyEven.pop_back();
        }
    }
}

void filterLuckyOdd() {
    for (size_t n = 2; n < luckyOdd.size(); ++n) {
        int m = luckyOdd[n - 1];
        int end = (luckyOdd.size() / m) * m - 1;
        for (int j = end; j >= m - 1; j -= m) {
            std::copy(luckyOdd.begin() + j + 1, luckyOdd.end(), luckyOdd.begin() + j);
            luckyOdd.pop_back();
        }
    }
}

void printBetween(size_t j, size_t k, bool even) {
    std::ostream_iterator<int> out_it{ std::cout, ", " };

    if (even) {
        size_t max = luckyEven.back();
        if (j > max || k > max) {
            std::cerr << "At least one are is too big\n";
            exit(EXIT_FAILURE);
        }

        std::cout << "Lucky even numbers between " << j << " and " << k << " are: ";
        std::copy_if(luckyEven.begin(), luckyEven.end(), out_it, [j, k](size_t n) {
            return j <= n && n <= k;
        });
    } else {
        size_t max = luckyOdd.back();
        if (j > max || k > max) {
            std::cerr << "At least one are is too big\n";
            exit(EXIT_FAILURE);
        }

        std::cout << "Lucky numbers between " << j << " and " << k << " are: ";
        std::copy_if(luckyOdd.begin(), luckyOdd.end(), out_it, [j, k](size_t n) {
            return j <= n && n <= k;
        });
    }
    std::cout << '\n';
}

void printRange(size_t j, size_t k, bool even) {
    std::ostream_iterator<int> out_it{ std::cout, ", " };
    if (even) {
        if (k >= luckyEven.size()) {
            std::cerr << "The argument is too large\n";
            exit(EXIT_FAILURE);
        }
        std::cout << "Lucky even numbers " << j << " to " << k << " are: ";
        std::copy(luckyEven.begin() + j - 1, luckyEven.begin() + k, out_it);
    } else {
        if (k >= luckyOdd.size()) {
            std::cerr << "The argument is too large\n";
            exit(EXIT_FAILURE);
        }
        std::cout << "Lucky numbers " << j << " to " << k << " are: ";
        std::copy(luckyOdd.begin() + j - 1, luckyOdd.begin() + k, out_it);
    }
}

void printSingle(size_t j, bool even) {
    if (even) {
        if (j >= luckyEven.size()) {
            std::cerr << "The argument is too large\n";
            exit(EXIT_FAILURE);
        }
        std::cout << "Lucky even number " << j << "=" << luckyEven[j - 1] << '\n';
    } else {
        if (j >= luckyOdd.size()) {
            std::cerr << "The argument is too large\n";
            exit(EXIT_FAILURE);
        }
        std::cout << "Lucky number " << j << "=" << luckyOdd[j - 1] << '\n';
    }
}

void help() {
    std::cout << "./lucky j [k] [--lucky|--evenLucky]\n";
    std::cout << "\n";
    std::cout << "       argument(s)        |  what is displayed\n";
    std::cout << "==============================================\n";
    std::cout << "-j=m                      |  mth lucky number\n";
    std::cout << "-j=m  --lucky             |  mth lucky number\n";
    std::cout << "-j=m  --evenLucky         |  mth even lucky number\n";
    std::cout << "-j=m  -k=n                |  mth through nth (inclusive) lucky numbers\n";
    std::cout << "-j=m  -k=n  --lucky       |  mth through nth (inclusive) lucky numbers\n";
    std::cout << "-j=m  -k=n  --evenLucky   |  mth through nth (inclusive) even lucky numbers\n";
    std::cout << "-j=m  -k=-n               |  all lucky numbers in the range [m, n]\n";
    std::cout << "-j=m  -k=-n  --lucky      |  all lucky numbers in the range [m, n]\n";
    std::cout << "-j=m  -k=-n  --evenLucky  |  all even lucky numbers in the range [m, n]\n";
}

int main(int argc, char **argv) {
    bool evenLucky = false;
    int j = 0;
    int k = 0;

    // skip arg 0, because that is just the executable name
    if (argc < 2) {
        help();
        exit(EXIT_FAILURE);
    }

    bool good = false;
    for (int i = 1; i < argc; ++i) {
        if ('-' == argv[i][0]) {
            if ('-' == argv[i][1]) {
                // long args
                if (0 == strcmp("--lucky", argv[i])) {
                    evenLucky = false;
                } else if (0 == strcmp("--evenLucky", argv[i])) {
                    evenLucky = true;
                } else {
                    std::cerr << "Unknown long argument: [" << argv[i] << "]\n";
                    exit(EXIT_FAILURE);
                }
            } else {
                // short args
                if ('j' == argv[i][1] && '=' == argv[i][2] && argv[i][3] != 0) {
                    good = true;
                    j = atoi(&argv[i][3]);
                } else if ('k' == argv[i][1] && '=' == argv[i][2]) {
                    k = atoi(&argv[i][3]);
                } else {
                    std::cerr << "Unknown short argument: " << argv[i] << '\n';
                    exit(EXIT_FAILURE);
                }
            }
        } else {
            std::cerr << "Unknown argument: " << argv[i] << '\n';
            exit(EXIT_FAILURE);
        }
    }
    if (!good) {
        help();
        exit(EXIT_FAILURE);
    }

    init();
    filterLuckyEven();
    filterLuckyOdd();
    if (k > 0) {
        printRange(j, k, evenLucky);
    } else if (k < 0) {
        printBetween(j, -k, evenLucky);
    } else {
        printSingle(j, evenLucky);
    }

    return 0;
}
