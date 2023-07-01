#include <iostream>
#include <optional>

std::optional<int> maybeInt()

int main()
{
  std::optional<int> maybe = maybeInt();

  if(!maybe)
    std::cout << "object is null\n";
}
