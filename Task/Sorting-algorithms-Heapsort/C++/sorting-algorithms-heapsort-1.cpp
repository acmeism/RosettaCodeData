#include <iostream>
#include <algorithm> // for std::make_heap, std::sort_heap

template <typename Iterator>
void heapsort(Iterator begin, Iterator end)
{
    std::make_heap(begin, end);
    std::sort_heap(begin, end);
}

int main()
{
    double valsToSort[] = {
        1.4, 50.2, 5.11, -1.55, 301.521, 0.3301, 40.17,
        -18.0, 88.1, 30.44, -37.2, 3012.0, 49.2};
    const int VSIZE = sizeof(valsToSort)/sizeof(*valsToSort);

    heapsort(valsToSort, valsToSort+VSIZE);
    for (int ix=0; ix<VSIZE; ix++) std::cout << valsToSort[ix] << std::endl;
    return 0;
}
