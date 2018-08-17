#include <iostream>
#include <stack>
#include <vector>

struct DataFrame {
  int sum;
  std::vector<int> coins;
  std::vector<int> avail_coins;
};

int main() {
  std::stack<DataFrame> s;
  s.push({ 100, {}, { 25, 10, 5, 1 } });
  int ways = 0;
  while (!s.empty()) {
    DataFrame top = s.top();
    s.pop();
    if (top.sum < 0) continue;
    if (top.sum == 0) {
      ++ways;
      continue;
    }
    if (top.avail_coins.empty()) continue;
    DataFrame d = top;
    d.sum -= top.avail_coins[0];
    d.coins.push_back(top.avail_coins[0]);
    s.push(d);
    d = top;
    d.avail_coins.erase(std::begin(d.avail_coins));
    s.push(d);
  }
  std::cout << ways << std::endl;
  return 0;
}
