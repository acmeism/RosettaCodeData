#include <iostream>
#include <numeric>
// Calculate the Forward Difference of a series if integers
//
// Nigel Galloway. August 20th., 2012
//
int main() {
    int x[] = {NULL,-43,11,-29,-7,10,23,-50,50,18};
    const int N = sizeof(x) / sizeof(int) - 1;
    for (int ord = 0; ord < N - 1; ord++) std::adjacent_difference(x+1, x + N + 1 - ord, x);
    std::cout << x[1] << std::endl;
    return 0;
}
