#include <iterator>
#include <algorithm>

template <typename Iterator>
double mean(Iterator begin, Iterator end)
{
    if (begin == end)
        return 0;
    return std::accumulate(begin, end, 0.0) / std::distance(begin, end);
}
