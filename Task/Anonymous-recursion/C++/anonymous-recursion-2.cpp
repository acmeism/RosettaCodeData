#include <functional>
using namespace std;

double fib(double n)
{
  if(n < 0)
    throw "Invalid argument";

  function<double(double)> actual_fib = [&](double n)
  {
    if(n < 2) return n;
    return actual_fib(n-1) + actual_fib(n-2);
  };

  return actual_fib(n);
}
