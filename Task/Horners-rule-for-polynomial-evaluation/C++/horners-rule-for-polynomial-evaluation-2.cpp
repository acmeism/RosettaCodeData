#include <iostream>

template<typename BidirIter>
 double horner(BidirIter begin, BidirIter end, double x)
{
  double result = 0;
  while (end != begin)
    result = result*x + *--end;
  return result;
}

int main()
{
  double c[] = { -19, 7, -4, 6 };
  std::cout << horner(c, c + 4, 3) << std::endl;
}
