#include <iostream>
#include <functional>
#include <vector>

int main() {
  std::vector<std::function<int()> > funcs;
  for (int i = 0; i < 10; i++)
    funcs.push_back([=]() { return i * i; });
  for ( std::function<int( )> f : funcs )
    std::cout << f( ) << std::endl ;
  return 0;
}
