// Using the proposed unbounded integer library

#include <iostream>
#include <seminumeric>

int main()
{
  try
  {
    auto i = std::experimental::seminumeric::integer{};

    while (true)
      std::cout << ++i << '\n';
  }
  catch (...)
  {
    // Do nothing
  }
}
