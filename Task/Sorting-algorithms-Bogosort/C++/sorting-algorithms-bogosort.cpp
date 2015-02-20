#include <algorithm>
#include <iostream>
#include <iterator>
#include <random>

template <typename RandomAccessIterator, typename Predicate>
void bogo_sort(RandomAccessIterator begin, RandomAccessIterator end,
               Predicate p) {
  std::random_device rd;
  std::mt19937 generator(rd());
  while (!std::is_sorted(begin, end, p)) {
    std::shuffle(begin, end, generator);
  }
}

template <typename RandomAccessIterator>
void bogo_sort(RandomAccessIterator begin, RandomAccessIterator end) {
  bogo_sort(
      begin, end,
      std::less<
          typename std::iterator_traits<RandomAccessIterator>::value_type>());
}

int main() {
  int a[] = {100, 2, 56, 200, -52, 3, 99, 33, 177, -199};
  bogo_sort(std::begin(a), std::end(a));
  copy(std::begin(a), std::end(a), std::ostream_iterator<int>(std::cout, " "));
  std::cout << "\n";
}
