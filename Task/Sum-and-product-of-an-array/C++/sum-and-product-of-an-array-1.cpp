#include <numeric>
#include <functional>

int arg[] = { 1, 2, 3, 4, 5 };
int sum  = std::accumulate(arg, arg+5, 0, std::plus<int>());
// or just
// std::accumulate(arg, arg + 5, 0);
// since plus() is the default functor for accumulate
int prod = std::accumulate(arg, arg+5, 1, std::multiplies<int>());
