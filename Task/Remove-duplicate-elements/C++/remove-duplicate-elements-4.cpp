#include <iostream>
#include <iterator>
#include <algorithm>

// helper template
template<typename T> T* end(T (&array)[size]) { return array+size; }

int main()
{
  int data[] = { 1, 2, 3, 2, 3, 4 };
  std::sort(data, end(data));
  int* new_end = std::unique(data, end(data));
  std::copy(data, new_end, std::ostream_iterator<int>(std::cout, " ");
  std::cout << std::endl;
}
