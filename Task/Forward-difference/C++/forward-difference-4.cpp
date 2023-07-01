#include <iostream>
#include <algorithm>
// Calculate the Forward Difference of a series if integers using Pascal's Triangle
// For this example the 9th line of Pascal's Triangle is stored in P.
//
// Nigel Galloway. August 20th., 2012
//
int main() {
    const int P[] = {1,-8,28,-56,70,-56,28,-8,1};
    int x[] = {-43,11,-29,-7,10,23,-50,50,18};
    std::transform(x, x + sizeof(x) / sizeof(int), P, x, std::multiplies<int>());
    std::cout << std::accumulate(x, x + sizeof(x) / sizeof(int), 0) << std::endl;
    return 0;
}
