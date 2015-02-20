#include <algorithm>
#include <iostream>
#include <iterator>

template <typename RandomAccessIterator>
void bubble_sort(RandomAccessIterator begin, RandomAccessIterator end) {
  bool swapped = true;
  while (begin != end-- && swapped) {
    swapped = false;
    for (auto i = begin; i != end; ++i) {
      if (*(i + 1) < *i) {
        std::iter_swap(i, i + 1);
        swapped = true;
      }
    }
  }
}

int main() {
  int a[] = {100, 2, 56, 200, -52, 3, 99, 33, 177, -199};
  bubble_sort(std::begin(a), std::end(a));
  copy(std::begin(a), std::end(a), std::ostream_iterator<int>(std::cout, " "));
  std::cout << "\n";
}
