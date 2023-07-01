#include <iostream>
#include <vector>
#include <algorithm>

enum { EMPTY, WALL, WATER };

auto fill(const std::vector<int> b) {
  auto water = 0;
  const auto rows = *std::max_element(std::begin(b), std::end(b));
  const auto cols = std::size(b);
  std::vector<std::vector<int>> g(rows);
  for (auto& r : g) {
    for (auto i = 0; i < cols; ++i) {
      r.push_back(EMPTY);
    }
  }
  for (auto c = 0; c < cols; ++c) {
    for (auto r = rows - 1u, i = 0u; i < b[c]; ++i, --r) {
      g[r][c] = WALL;
    }
  }
  for (auto c = 0; c < cols - 1; ++c) {
    auto start_row = rows - b[c];
    while (start_row < rows) {
      if (g[start_row][c] == EMPTY) break;
      auto c2 = c + 1;
      bool hitWall = false;
      while (c2 < cols) {
        if (g[start_row][c2] == WALL) {
          hitWall = true;
          break;
        }
        ++c2;
      }
      if (hitWall) {
        for (auto i = c + 1; i < c2; ++i) {
          g[start_row][i] = WATER;
          ++water;
        }
      }
      ++start_row;
    }
  }
  return water;
}

int main() {
  std::vector<std::vector<int>> b = {
    { 1, 5, 3, 7, 2 },
    { 5, 3, 7, 2, 6, 4, 5, 9, 1, 2 },
    { 2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1 },
    { 5, 5, 5, 5 },
    { 5, 6, 7, 8 },
    { 8, 7, 7, 6 },
    { 6, 7, 10, 7, 6 }
  };
  for (const auto v : b) {
    auto water = fill(v);
    std::cout << water << " water drops." << std::endl;
  }
  std::cin.ignore();
  std::cin.get();
  return 0;
}
