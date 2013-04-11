// this would be more elegant using STL collections
template <typename T> T sum (const T *array, const unsigned n)
{
    T accum = 0;
    for (unsigned i=0; i<n; i++)
        accum += array[i];
    return accum;
}
template <typename T> T prod (const T *array, const unsigned n)
{
    T accum = 1;
    for (unsigned i=0; i<n; i++)
        accum *= array[i];
    return accum;
}

#include <iostream>
using std::cout;
using std::endl;

int main ()
{
    int aint[] = {1, 2, 3};
    cout << sum(aint,3) << " " << prod(aint, 3) << endl;
    float aflo[] = {1.1, 2.02, 3.003, 4.0004};
    cout << sum(aflo,4) << " " << prod(aflo,4) << endl;
    return 0;
}
