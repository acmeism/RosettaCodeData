#include <iostream>
#include <vector>
#include <algorithm>
#include <string>

template <typename T>
void print(const std::vector<T> v) {
  std::cout << "{ ";
  for (const auto& e : v) {
    std::cout << e << " ";
  }
  std::cout << "}";
}

template <typename T>
auto orderDisjointArrayItems(std::vector<T> M, std::vector<T> N) {
  std::vector<T*> M_p(std::size(M));
  for (auto i = 0; i < std::size(M_p); ++i) {
    M_p[i] = &M[i];
  }
  for (auto e : N) {
    auto i = std::find_if(std::begin(M_p), std::end(M_p), [e](auto c) -> bool {
      if (c != nullptr) {
        if (*c == e) return true;
      }
      return false;
    });
    if (i != std::end(M_p)) {
      *i = nullptr;
    }
  }
  for (auto i = 0; i < std::size(N); ++i) {
    auto j = std::find_if(std::begin(M_p), std::end(M_p), [](auto c) -> bool {
      return c == nullptr;
    });
    if (j != std::end(M_p)) {
      *j = &M[std::distance(std::begin(M_p), j)];
      **j = N[i];
    }
  }
  return M;
}

int main() {
  std::vector<std::vector<std::vector<std::string>>> l = {
    { { "the", "cat", "sat", "on", "the", "mat" }, { "mat", "cat" } },
    { { "the", "cat", "sat", "on", "the", "mat" },{ "cat", "mat" } },
    { { "A", "B", "C", "A", "B", "C", "A", "B", "C" },{ "C", "A", "C", "A" } },
    { { "A", "B", "C", "A", "B", "D", "A", "B", "E" },{ "E", "A", "D", "A" } },
    { { "A", "B" },{ "B" } },
    { { "A", "B" },{ "B", "A" } },
    { { "A", "B", "B", "A" },{ "B", "A" } }
  };
  for (const auto& e : l) {
    std::cout << "M: ";
    print(e[0]);
    std::cout << ", N: ";
    print(e[1]);
    std::cout << ", M': ";
    auto res = orderDisjointArrayItems<std::string>(e[0], e[1]);
    print(res);
    std::cout << std::endl;
  }
  std::cin.ignore();
  std::cin.get();
  return 0;
}
