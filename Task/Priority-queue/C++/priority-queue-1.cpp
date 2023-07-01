#include <iostream>
#include <string>
#include <queue>
#include <utility>

int main() {
  std::priority_queue<std::pair<int, std::string> > pq;
  pq.push(std::make_pair(3, "Clear drains"));
  pq.push(std::make_pair(4, "Feed cat"));
  pq.push(std::make_pair(5, "Make tea"));
  pq.push(std::make_pair(1, "Solve RC tasks"));
  pq.push(std::make_pair(2, "Tax return"));

  while (!pq.empty()) {
    std::cout << pq.top().first << ", " << pq.top().second << std::endl;
    pq.pop();
  }

  return 0;
}
