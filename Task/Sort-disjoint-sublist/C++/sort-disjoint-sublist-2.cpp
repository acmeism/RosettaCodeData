#include <algorithm>
#include <iostream>
#include <iterator>
#include <vector>

template <typename ValueIterator, typename IndicesIterator>
struct DisjointSubsetIterator :
  public std::iterator<std::random_access_iterator_tag,
		       typename std::iterator_traits<ValueIterator>::value_type> {
  typedef typename std::iterator_traits<ValueIterator>::value_type V;
  ValueIterator valsBegin;
  IndicesIterator i;
  DisjointSubsetIterator() { }
  DisjointSubsetIterator(const ValueIterator &_v, IndicesIterator _i) :
    valsBegin(_v), i(_i) { }
  DisjointSubsetIterator& operator++() { ++i; return *this; }
  DisjointSubsetIterator operator++(int) {
    DisjointSubsetIterator tmp = *this; ++(*this); return tmp; }
  bool operator==(const DisjointSubsetIterator& y) { return i == y.i; }
  bool operator!=(const DisjointSubsetIterator& y) { return i != y.i; }
  V &operator*() { return valsBegin[*i]; }
  DisjointSubsetIterator& operator--() { --i; return *this; }
  DisjointSubsetIterator operator--(int) {
    DisjointSubsetIterator tmp = *this; --(*this); return tmp; }
  DisjointSubsetIterator& operator+=(int n) { i += n; return *this; }
  DisjointSubsetIterator& operator-=(int n) { i -= n; return *this; }
  DisjointSubsetIterator operator+(int n) {
    DisjointSubsetIterator tmp = *this; return tmp += n; }
  DisjointSubsetIterator operator-(int n) {
    DisjointSubsetIterator tmp = *this; return tmp -= n; }
  int operator-(const DisjointSubsetIterator &y) { return i - y.i; }
  V &operator[](int n) { return *(*this + n); }
  bool operator<(const DisjointSubsetIterator &y) { return i < y.i; }
  bool operator>(const DisjointSubsetIterator &y) { return i > y.i; }
  bool operator<=(const DisjointSubsetIterator &y) { return i <= y.i; }
  bool operator>=(const DisjointSubsetIterator &y) { return i >= y.i; }
};
template <typename ValueIterator, typename IndicesIterator>
DisjointSubsetIterator<ValueIterator, IndicesIterator>
operator+(int n, const DisjointSubsetIterator<ValueIterator, IndicesIterator> &i) {
  return i + n; }

template <typename ValueIterator, typename IndicesIterator>
void sortDisjoint(ValueIterator valsBegin, IndicesIterator indicesBegin,
		  IndicesIterator indicesEnd) {
  std::sort(DisjointSubsetIterator<ValueIterator, IndicesIterator>(valsBegin, indicesBegin),
            DisjointSubsetIterator<ValueIterator, IndicesIterator>(valsBegin, indicesEnd));
}
		

int main()
{
    int values[] = { 7, 6, 5, 4, 3, 2, 1, 0 };
    int indices[] = { 6, 1, 7 };

    sortDisjoint(values, indices, indices+3);

    std::copy(values, values + 8, std::ostream_iterator<int>(std::cout, " "));
    std::cout << "\n";

    return 0;
}
