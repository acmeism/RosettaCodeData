#include <iostream>

template <int n, int m3, int m5>
struct fizzbuzz : fizzbuzz<n-1, (n-1)%3, (n-1)%5>
{
  fizzbuzz()
  { std::cout << n << std::endl; }
};

template <int n>
struct fizzbuzz<n, 0, 0> : fizzbuzz<n-1, (n-1)%3, (n-1)%5>
{
  fizzbuzz()
  { std::cout << "FizzBuzz" << std::endl; }
};

template <int n, int p>
struct fizzbuzz<n, 0, p> : fizzbuzz<n-1, (n-1)%3, (n-1)%5>
{
  fizzbuzz()
  { std::cout << "Fizz" << std::endl; }
};

template <int n, int p>
struct fizzbuzz<n, p, 0> : fizzbuzz<n-1, (n-1)%3, (n-1)%5>
{
  fizzbuzz()
  { std::cout << "Buzz" << std::endl; }
};

template <>
struct fizzbuzz<0,0,0>
{
  fizzbuzz()
  { std::cout << 0 << std::endl; }
};

template <int n>
struct fb_run
{
  fizzbuzz<n, n%3, n%5> fb;
};

int main()
{
  fb_run<100> fb;
  return 0;
}
