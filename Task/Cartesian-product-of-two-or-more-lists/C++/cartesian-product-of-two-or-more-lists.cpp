#include <iostream>
#include <vector>
#include <algorithm>

void print(const std::vector<std::vector<int>>& v) {
  std::cout << "{ ";
  for (const auto& p : v) {
    std::cout << "(";
    for (const auto& e : p) {
      std::cout << e << " ";
    }
    std::cout << ") ";
  }
  std::cout << "}" << std::endl;
}

auto product(const std::vector<std::vector<int>>& lists) {
  std::vector<std::vector<int>> result;
  if (std::find_if(std::begin(lists), std::end(lists),
    [](auto e) -> bool { return e.size() == 0; }) != std::end(lists)) {
    return result;
  }
  for (auto& e : lists[0]) {
    result.push_back({ e });
  }
  for (size_t i = 1; i < lists.size(); ++i) {
    std::vector<std::vector<int>> temp;
    for (auto& e : result) {
      for (auto f : lists[i]) {
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
  std::vector<std::vector<int>> prods[] = {
    { { 1, 2 }, { 3, 4 } },
    { { 3, 4 }, { 1, 2} },
    { { 1, 2 }, { } },
    { { }, { 1, 2 } },
    { { 1776, 1789 }, { 7, 12 }, { 4, 14, 23 }, { 0, 1 } },
    { { 1, 2, 3 }, { 30 }, { 500, 100 } },
    { { 1, 2, 3 }, { }, { 500, 100 } }
  };
  for (const auto& p : prods) {
    print(product(p));
  }
  std::cin.ignore();
  std::cin.get();
  return 0;
}
