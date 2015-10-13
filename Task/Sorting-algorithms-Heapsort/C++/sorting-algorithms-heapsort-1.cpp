#include <algorithm>
#include <iterator>
#include <iostream>

template<typename RandomAccessIterator>
void heap_sort(RandomAccessIterator begin, RandomAccessIterator end) {
  std::make_heap(begin, end);
  std::sort_heap(begin, end);
}

int main() {
  int a[] = {100, 2, 56, 200, -52, 3, 99, 33, 177, -199};
  heap_sort(std::begin(a), std::end(a));
  copy(std::begin(a), std::end(a), std::ostream_iterator<int>(std::cout, " "));
  std::cout << "\n";
}
