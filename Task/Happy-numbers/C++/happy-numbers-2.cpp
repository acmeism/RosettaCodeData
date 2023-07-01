unsigned int happy_iteration(unsigned int n)
{
  unsigned int result = 0;
  while (n > 0)
  {
    unsigned int lastdig = n % 10;
    result += lastdig*lastdig;
    n /= 10;
  }
  return result;
}

bool is_happy(unsigned int n)
{
  unsigned int n2 = happy_iteration(n);
  while (n != n2)
  {
    n = happy_iteration(n);
    n2 = happy_iteration(happy_iteration(n2));
  }
  return n == 1;
}

#include <iostream>

int main()
{
  unsigned int current_number = 1;

  unsigned int happy_count = 0;
  while (happy_count != 8)
  {
    if (is_happy(current_number))
    {
      std::cout << current_number << " ";
      ++happy_count;
    }
    ++current_number;
  }
  std::cout << std::endl;
}
