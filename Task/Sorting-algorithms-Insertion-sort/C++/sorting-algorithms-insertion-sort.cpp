#include <algorithm>
#include <iostream>
#include <iterator>

template <typename RandomAccessIterator, typename Predicate>
void insertion_sort(RandomAccessIterator begin, RandomAccessIterator end,
                    Predicate p) {
  for (auto i = begin; i != end; ++i) {
    std::rotate(std::upper_bound(begin, i, *i, p), i, i + 1);
  }
}

template <typename RandomAccessIterator>
void insertion_sort(RandomAccessIterator begin, RandomAccessIterator end) {
  insertion_sort(
      begin, end,
      std::less<
          typename std::iterator_traits<RandomAccessIterator>::value_type>());
}

int main() {
  int a[] = { 100, 2, 56, 200, -52, 3, 99, 33, 177, -199 };
  insertion_sort(std::begin(a), std::end(a));
  copy(std::begin(a), std::end(a), std::ostream_iterator<int>(std::cout, " "));
  std::cout << "\n";
}
