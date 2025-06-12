#include <algorithm>
#include <iostream>
#include <vector>

void print_inner(const std::vector<int> &v) {
    std::cout << "(";
    auto it = v.begin();
    if (!v.empty()) {
        std::cout << *it++; // Yield beginning value, then advance
    }
    for (; it != v.end(); ++it) {
        std::cout << ", " << *it;
    }
    std::cout << ")";
}

void print(const std::vector<std::vector<int> > &v) {
    std::cout << "[";
    auto it = v.begin();
    if (!v.empty()) {
        print_inner(*it++); // Yield beginning value, then advance
    }
    for (; it != v.end(); ++it) {
        std::cout << ", ";
        print_inner(*it);
    }
    std::cout << "]\n";
}

auto product(const std::vector<std::vector<int> > &lists) {
    std::vector<std::vector<int> > result;
    if (std::find_if(std::begin(lists), std::end(lists),
                     [](const auto &e) -> bool { return e.empty(); }) != std::end(lists)) {
        return result;
    }
    for (auto &e: lists[0]) {
        result.push_back({e});
    }
    for (size_t i = 1; i < lists.size(); ++i) {
        std::vector<std::vector<int> > temp;
        for (const auto &e: result) {
            for (auto f: lists[i]) {
                auto e_tmp = e;
                e_tmp.push_back(f);
                temp.push_back(e_tmp);
            }
        }
        result = temp;
    }
    return result;
}

int main() {
    std::vector<std::vector<int> > prods[] = {
        {{1, 2}, {3, 4}},
        {{3, 4}, {1, 2}},
        {{1, 2}, {}},
        {{}, {1, 2}},
        {{1776, 1789}, {7, 12}, {4, 14, 23}, {0, 1}},
        {{1, 2, 3}, {30}, {500, 100}},
        {{1, 2, 3}, {}, {500, 100}}
    };
    for (const auto &p: prods) {
        print(product(p));
    }
}
