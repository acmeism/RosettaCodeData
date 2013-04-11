#include <algorithm>
#include <ext/algorithm>

template<typename ForwardIterator>
 void bogosort(ForwardIterator begin, ForwardIterator end)
{
  while (!__gnu_cxx::is_sorted(begin, end))
    std::random_shuffle(begin, end);
}
