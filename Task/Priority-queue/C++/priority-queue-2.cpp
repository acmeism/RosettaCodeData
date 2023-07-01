#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <utility>

int main() {
  std::vector<std::pair<int, std::string> > pq;
  pq.push_back(std::make_pair(3, "Clear drains"));
  pq.push_back(std::make_pair(4, "Feed cat"));
  pq.push_back(std::make_pair(5, "Make tea"));
  pq.push_back(std::make_pair(1, "Solve RC tasks"));

  // heapify
  std::make_heap(pq.begin(), pq.end());

  // enqueue
  pq.push_back(std::make_pair(2, "Tax return"));
  std::push_heap(pq.begin(), pq.end());

  while (!pq.empty()) {
    // peek
    std::cout << pq[0].first << ", " << pq[0].second << std::endl;
    // dequeue
    std::pop_heap(pq.begin(), pq.end());
    pq.pop_back();
  }

  return 0;
}
