#include <algorithm>
#include <iostream>
#include <vector>

std::vector<int> digits(int n) {
    std::vector<int> result;
    while (n > 0) {
        auto rem = n % 10;
        result.push_back(rem);
        n /= 10;
    }
    std::reverse(result.begin(), result.end());
    return result;
}

bool is_strange(int n) {
    auto test = [](int a, int b) {
        auto v = std::abs(a - b);
        return v == 2 || v == 3 || v == 5 || v == 7;
    };

    auto xs = digits(n);
    for (size_t i = 1; i < xs.size(); i++) {
        if (!test(xs[i - 1], xs[i])) {
            return false;
        }
    }
    return true;
}

int main() {
    std::vector<int> xs;
    for (int i = 100; i <= 500; i++) {
        if (is_strange(i)) {
            xs.push_back(i);
        }
    }

    std::cout << "Strange numbers in range [100..500]\n";
    std::cout << "(Total: " << xs.size() << ")\n\n";

    for (size_t i = 0; i < xs.size(); i++) {
        std::cout << xs[i];
        if ((i + 1) % 10 == 0) {
            std::cout << '\n';
        } else {
            std::cout << ' ';
        }
    }

    return 0;
}
