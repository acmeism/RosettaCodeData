#include <boost/optional.hpp>
#include <iostream>

boost::optional<int> maybeInt()

int main()
{
  boost::optional<int> maybe = maybeInt();

  if(!maybe)
    std::cout << "object is null\n";
}
