#include <algorithm>
#include <iostream>
#include <iterator>
#include <vector>

template <typename ValueIterator, typename IndicesIterator>
void sortDisjoint(ValueIterator valsBegin, IndicesIterator indicesBegin,
		  IndicesIterator indicesEnd) {
    std::vector<int> temp;

    for (IndicesIterator i = indicesBegin; i != indicesEnd; ++i)
        temp.push_back(valsBegin[*i]); // extract

    std::sort(indicesBegin, indicesEnd); // sort
    std::sort(temp.begin(), temp.end()); // sort a C++ container

    std::vector<int>::const_iterator j = temp.begin();
    for (IndicesIterator i = indicesBegin; i != indicesEnd; ++i, ++j)
        valsBegin[*i] = *j; // replace
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
