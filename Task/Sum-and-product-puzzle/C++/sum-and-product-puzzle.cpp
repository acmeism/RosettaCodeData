#include <algorithm>
#include <iostream>
#include <map>
#include <vector>

std::ostream &operator<<(std::ostream &os, std::vector<std::pair<int, int>> &v) {
    for (auto &p : v) {
        auto sum = p.first + p.second;
        auto prod = p.first * p.second;
        os << '[' << p.first << ", " << p.second << "] S=" << sum << " P=" << prod;
    }
    return os << '\n';
}

void print_count(const std::vector<std::pair<int, int>> &candidates) {
    auto c = candidates.size();
    if (c == 0) {
        std::cout << "no candidates\n";
    } else if (c == 1) {
        std::cout << "one candidate\n";
    } else {
        std::cout << c << " candidates\n";
    }
}

auto setup() {
    std::vector<std::pair<int, int>> candidates;

    // numbers must be greater than 1
    for (int x = 2; x <= 98; x++) {
        // numbers must be unique, and sum no more than 100
        for (int y = x + 1; y <= 98; y++) {
            if (x + y <= 100) {
                candidates.push_back(std::make_pair(x, y));
            }
        }
    }

    return candidates;
}

void remove_by_sum(std::vector<std::pair<int, int>> &candidates, const int sum) {
    candidates.erase(std::remove_if(
        candidates.begin(), candidates.end(),
        [sum](const std::pair<int, int> &pair) {
            auto s = pair.first + pair.second;
            return s == sum;
        }
    ), candidates.end());
}

void remove_by_prod(std::vector<std::pair<int, int>> &candidates, const int prod) {
    candidates.erase(std::remove_if(
        candidates.begin(), candidates.end(),
        [prod](const std::pair<int, int> &pair) {
            auto p = pair.first * pair.second;
            return p == prod;
        }
    ), candidates.end());
}

void statement1(std::vector<std::pair<int, int>> &candidates) {
    std::map<int, int> uniqueMap;

    std::for_each(
        candidates.cbegin(), candidates.cend(),
        [&uniqueMap](const std::pair<int, int> &pair) {
            auto prod = pair.first * pair.second;
            uniqueMap[prod]++;
        }
    );

    bool loop;
    do {
        loop = false;
        for (auto &pair : candidates) {
            auto prod = pair.first * pair.second;
            if (uniqueMap[prod] == 1) {
                auto sum = pair.first + pair.second;
                remove_by_sum(candidates, sum);

                loop = true;
                break;
            }
        }
    } while (loop);
}

void statement2(std::vector<std::pair<int, int>> &candidates) {
    std::map<int, int> uniqueMap;

    std::for_each(
        candidates.cbegin(), candidates.cend(),
        [&uniqueMap](const std::pair<int, int> &pair) {
            auto prod = pair.first * pair.second;
            uniqueMap[prod]++;
        }
    );

    bool loop;
    do {
        loop = false;
        for (auto &pair : candidates) {
            auto prod = pair.first * pair.second;
            if (uniqueMap[prod] > 1) {
                remove_by_prod(candidates, prod);

                loop = true;
                break;
            }
        }
    } while (loop);
}

void statement3(std::vector<std::pair<int, int>> &candidates) {
    std::map<int, int> uniqueMap;

    std::for_each(
        candidates.cbegin(), candidates.cend(),
        [&uniqueMap](const std::pair<int, int> &pair) {
            auto sum = pair.first + pair.second;
            uniqueMap[sum]++;
        }
    );

    bool loop;
    do {
        loop = false;
        for (auto &pair : candidates) {
            auto sum = pair.first + pair.second;
            if (uniqueMap[sum] > 1) {
                remove_by_sum(candidates, sum);

                loop = true;
                break;
            }
        }
    } while (loop);
}

int main() {
    auto candidates = setup();
    print_count(candidates);

    statement1(candidates);
    print_count(candidates);

    statement2(candidates);
    print_count(candidates);

    statement3(candidates);
    print_count(candidates);

    std::cout << candidates;

    return 0;
}
