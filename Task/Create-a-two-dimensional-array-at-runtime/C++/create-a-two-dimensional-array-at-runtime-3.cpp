#include <iostream>
#include "boost/multi_array.hpp"

typedef boost::multi_array<double, 2> two_d_array_type;

int main()
{
    // read values
    int dim1, dim2;
    std::cin >> dim1 >> dim2;

    // create array
    two_d_array_type A(boost::extents[dim1][dim2]);

    // write elements
    A[0][0] = 3.1415;

    // read elements
    std::cout << A[0][0] << std::endl;
}
