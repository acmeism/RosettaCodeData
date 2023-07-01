#include <vector>
#include <algorithm>
#include <iterator>

// this assumes T is default-constructible
std::vector<T> vec1(n); // all n objects are default-initialized

// this assumes t is a value of type T (or a type which implicitly converts to T)
std::vector<T> vec2(n, t); // all n objects are copy-initialized with t

// To initialise each value differently
std::generate_n(std::back_inserter(vec), n, makeT); //makeT is a function of type T(void)
