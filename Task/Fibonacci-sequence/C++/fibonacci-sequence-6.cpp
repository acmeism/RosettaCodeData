#include <iostream>

inline void fibmul(int* f, int* g)
{
  int tmp = f[0]*g[0] + f[1]*g[1];
  f[1] = f[0]*g[1] + f[1]*(g[0] + g[1]);
  f[0] = tmp;
}

int fibonacci(int n)
{
  int f[] = { 1, 0 };
  int g[] = { 0, 1 };
  while (n > 0)
  {
    if (n & 1) // n odd
    {
      fibmul(f, g);
      --n;
    }
    else
    {
      fibmul(g, g);
      n >>= 1;
    }
  }
  return f[1];
}

int main()
{
  for (int i = 0; i < 20; ++i)
    std::cout << fibonacci(i) << " ";
  std::cout << std::endl;
}
