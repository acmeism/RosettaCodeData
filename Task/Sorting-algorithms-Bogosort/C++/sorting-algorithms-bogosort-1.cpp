#include <iterator>
#include <algorithm>

template<typename ForwardIterator>
 void bogosort(ForwardIterator begin, ForwardIterator end)
{
  typedef std::iterator_traits<ForwardIterator>::value_type value_type;

  // if we find two adjacent values where the first is greater than the second, the sequence isn't sorted.
  while (std::adjacent_find(begin, end, std::greater<value_type>()) != end)
    std::random_shuffle(begin, end);
}
