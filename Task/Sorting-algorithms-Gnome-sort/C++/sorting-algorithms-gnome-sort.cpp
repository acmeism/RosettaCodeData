#include <algorithm>
#include <iterator>
#include <iostream>

template<typename RandomAccessIterator>
void gnome_sort(RandomAccessIterator begin, RandomAccessIterator end) {
  auto i = begin + 1;
  auto j = begin + 2;

  while (i < end) {
    if (!(*i < *(i - 1))) {
      i = j;
      ++j;
    } else {
      std::iter_swap(i - 1, i);
      --i;
      if (i == begin) {
        i = j;
        ++j;
      }
    }
  }
}

int main() {
  int a[] = {100, 2, 56, 200, -52, 3, 99, 33, 177, -199};
  gnome_sort(std::begin(a), std::end(a));
  copy(std::begin(a), std::end(a), std::ostream_iterator<int>(std::cout, " "));
  std::cout << "\n";
}
