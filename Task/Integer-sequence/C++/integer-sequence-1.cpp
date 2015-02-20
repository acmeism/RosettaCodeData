#include <cstdint>
#include <iostream>
#include <limits>

int main()
{
  auto i = std::uintmax_t{};

  while (i < std::numeric_limits<decltype(i)>::max())
    std::cout << ++i << '\n';
}
