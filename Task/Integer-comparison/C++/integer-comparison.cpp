#include <iostream>

int main()
{
  int a, b;

  if (!(std::cin >> a >> b)) {
    std::cerr << "could not read the numbers\n";
    return 1;
  }

  // test for less-than
  if (a < b)
    std::cout << a << " is less than " << b << "\n";

  // test for equality
  if (a == b)
    std::cout << a << " is equal to " << b << "\n";

  // test for greater-than
  if (a > b)
    std::cout << a << " is greater than " << b << "\n";
}
