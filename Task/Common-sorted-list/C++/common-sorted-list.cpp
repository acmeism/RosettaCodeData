#include <iostream>
#include <vector>
#include <set>
#include <algorithm>

template<typename T>
std::vector<T> common_sorted_list(const std::vector<std::vector<T>>& ll) {
    std::set<T> resultset;
    std::vector<T> result;
    for (auto& list : ll)
        for (auto& item : list)
            resultset.insert(item);
    for (auto& item : resultset)
        result.push_back(item);

    std::sort(result.begin(), result.end());
    return result;
}

int main() {
    std::vector<int> a = {5,1,3,8,9,4,8,7};
    std::vector<int> b = {3,5,9,8,4};
    std::vector<int> c = {1,3,7,9};
    std::vector<std::vector<int>> nums = {a, b, c};

    auto csl = common_sorted_list(nums);
    for (auto n : csl) std::cout << n << " ";
    std::cout << std::endl;

    return 0;
}
