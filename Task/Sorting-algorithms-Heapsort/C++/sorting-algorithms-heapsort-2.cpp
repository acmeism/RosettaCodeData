#include <iostream>
#include <algorithm> // for std::make_heap, std::pop_heap

template <typename Iterator>
void heapsort(Iterator begin, Iterator end)
{
    std::make_heap(begin, end);
    while (begin != end)
        std::pop_heap(begin, end--);
}
