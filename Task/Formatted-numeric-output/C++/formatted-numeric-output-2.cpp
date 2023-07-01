#include <iostream>
#include <format>

int main()
{
  std::cout << std::format("{:09.3f}\n", 7.125);
  return 0;
}
